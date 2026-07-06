import argparse
import pandas as pd

# ----------------------------------------------------------------------
# Arguments
# ----------------------------------------------------------------------

def parse_args():
    parser = argparse.ArgumentParser(
        description="Preparation des fichiers edges/nodes pour le reseau de co-occurrences (LR)."
    )

    # Fichiers resultats_cooccurrences.tsv (un par echantillon, ordre: E1-1 H1-8 C3-1)
    parser.add_argument(
        "--coocc", required=True, nargs=3, metavar=("E1_COOC", "H1_COOC", "C3_COOC"),
        help="3 fichiers resultats_cooccurrences.tsv dans l'ordre E1-1 H1-8 C3-1",
    )
    # Fichiers resultats_cooccurrences_summary.tsv (counts)
    parser.add_argument(
        "--summary", required=True, nargs=3, metavar=("E1_SUMMARY", "H1_SUMMARY", "C3_SUMMARY"),
        help="3 fichiers resultats_cooccurrences_summary.tsv dans l'ordre E1-1 H1-8 C3-1",
    )
    # Fichiers de couverture gcpm.txt
    parser.add_argument(
        "--gcpm", required=True, nargs=3, metavar=("E1_GCPM", "H1_GCPM", "C3_GCPM"),
        help="3 fichiers gcpm.txt dans l'ordre E1-1 H1-8 C3-1",
    )

    # Fichiers de sortie
    parser.add_argument("--out-nodes", default="nodes.csv", help="Chemin du fichier nodes_LR.csv en sortie")
    parser.add_argument("--out-edges", default="edges.csv", help="Chemin du fichier edges_LR.csv en sortie")

    return parser.parse_args()

args = parse_args()

SAMPLE_LABELS_EDGES = ["Vegetable", "Pork", "Seafood"]    # E1-1, H1-8, C3-1
SAMPLE_LABELS_COV = ["E1-1_LR", "H1-8_LR", "C3-1_LR"]

EDGES_PATHS = dict(zip(SAMPLE_LABELS_EDGES, args.coocc))
COUNTS_PATHS = list(args.summary)
COV_PATHS = dict(zip(SAMPLE_LABELS_COV, args.gcpm))

OUT_NODES = args.out_nodes
OUT_EDGES = args.out_edges

GENE_RENAME_MAP = {
    "LRA1": "BLALRA1",
    "RM3": "BLARM3",
    "OXA662": "BLAOXA662",
    "OXA956": "BLAOXA956",
    "OXA296": "BLAOXA296",
    "ESP1": "BLAESP1",
    "THINB": "BLATHINB",
}


# ----------------------------------------------------------------------
# Fonctions utilitaires
# ----------------------------------------------------------------------

def str_remove_dash(series: pd.Series) -> pd.Series:
    """Equivalent de str_remove(x, '-') : supprime la PREMIERE occurrence de '-'."""
    return series.str.replace("-", "", n=1, regex=False)


def str_remove_trailing_number(series: pd.Series) -> pd.Series:
    """Equivalent de str_remove(x, '_\\d+$') : supprime un suffixe '_<chiffres>' en fin de chaine."""
    return series.str.replace(r"_\d+$", "", regex=True)


def clean_gene_cols(df: pd.DataFrame) -> pd.DataFrame:
    df["gene1"] = str_remove_dash(df["gene1"])
    df["gene1"] = str_remove_trailing_number(df["gene1"])
    df["gene2"] = str_remove_dash(df["gene2"])
    df["gene2"] = str_remove_trailing_number(df["gene2"])
    return df


# ----------------------------------------------------------------------
# Construction des EDGES
# ----------------------------------------------------------------------

def build_edges() -> pd.DataFrame:
    dfs = []
    for lm_label, path in EDGES_PATHS.items():
        df = pd.read_csv(path, sep="\t")
        df = df.drop(columns=["source1", "source2", "contig"])
        df["Lm"] = lm_label
        dfs.append(df)

    edges = pd.concat(dfs, ignore_index=True)
    edges = clean_gene_cols(edges)

    edges = edges[edges["gene1"] != edges["gene2"]]
    edges = edges[(edges["category1"] != "MGE") | (edges["category2"] != "MGE")]

    edges = (
        edges.groupby(["gene1", "category1", "gene2", "category2", "Lm"], as_index=False)
        .size()
        .drop(columns="size")
    )

    return edges


def process_count(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, sep="\t")
    if df.empty:
        return pd.DataFrame(columns=["gene1", "gene2", "count"])
    df[["gene1", "gene2"]] = df["paire"].str.split(r"\|", n=1, expand=True)
    df = df.drop(columns="paire")
    df = df.apply(lambda col: col.str.strip() if col.dtype == "object" else col)
    return df


def build_edges_final(edges: pd.DataFrame) -> pd.DataFrame:
    all_count = pd.concat([process_count(p) for p in COUNTS_PATHS], ignore_index=True)

    all_count["count"] = pd.to_numeric(all_count["count"], errors="coerce")
    all_count = clean_gene_cols(all_count)

    all_count = all_count[all_count["gene1"] != all_count["gene2"]]
    all_count = all_count[all_count["gene1"] != "REQUIRESSNPCONFIRMATION"]
    all_count = all_count[all_count["gene2"] != "REQUIRESSNPCONFIRMATION"]

    all_count = (
        all_count.groupby(["gene1", "gene2"], as_index=False)["count"].sum(min_count=1)
    )
    all_count["count"] = all_count["count"].fillna(0).astype(int)

    edges_final = edges.merge(all_count, on=["gene1", "gene2"], how="left")
    edges_final = edges_final.drop(columns=["category1", "category2"])
    edges_final = edges_final[["gene1", "gene2", "count", "Lm"]]

    edges_final = edges_final[edges_final["gene1"] != "REQUIRESSNPCONFIRMATION"]
    edges_final = edges_final[edges_final["gene2"] != "REQUIRESSNPCONFIRMATION"]

    edges_final["gene1"] = edges_final["gene1"].replace("PSEUDOMONAS_AERUGINOSA_CPXR", "CPXAR")
    edges_final["gene2"] = edges_final["gene2"].replace("PSEUDOMONAS_AERUGINOSA_CPXR", "CPXAR")

    edges_final["gene1"] = edges_final["gene1"].replace(GENE_RENAME_MAP)
    edges_final["gene2"] = edges_final["gene2"].replace(GENE_RENAME_MAP)

    edges_final = edges_final[edges_final["gene1"] != edges_final["gene2"]]
    edges_final = edges_final.drop_duplicates(subset=["gene1", "gene2", "Lm"], keep="first")

    return edges_final


# ----------------------------------------------------------------------
# Construction des NODES
# ----------------------------------------------------------------------

def remove_trailing_number_contig(series: pd.Series) -> pd.Series:
    return series.str.replace(r"_\d+$", "", regex=True)


def build_nodes(active_nodes: set) -> pd.DataFrame:
    dfs = []
    for label, path in EDGES_PATHS.items():
        df = pd.read_csv(path, sep="\t")
        df = df.drop(columns=["source1", "source2"])
        dfs.append(df)
    all_nodes = pd.concat(dfs, ignore_index=True)

    nodes = pd.concat(
        [
            all_nodes[["contig", "gene1", "category1"]].rename(
                columns={"gene1": "gene", "category1": "category"}
            ),
            all_nodes[["contig", "gene2", "category2"]].rename(
                columns={"gene2": "gene", "category2": "category"}
            ),
        ],
        ignore_index=True,
    )

    cov_dfs = []
    for label, path in COV_PATHS.items():
        df = pd.read_csv(path, sep="\t", header=None)
        df.columns = ["contig", "longueur_gene", "nb_bases_mappees", "GCPM_LR"]
        df["sample"] = label
        cov_dfs.append(df)
    cov = pd.concat(cov_dfs, ignore_index=True)
    cov["contig"] = remove_trailing_number_contig(cov["contig"])
    cov = cov.groupby(["sample", "contig"], as_index=False)["GCPM_LR"].sum(min_count=1)

    nodes = nodes.merge(cov, on="contig", how="left")
    nodes = nodes.groupby(["gene", "category"], as_index=False)["GCPM_LR"].mean()
    nodes = nodes.rename(columns={"GCPM_LR": "GCPM"})

    # gene cleanup + seconde agregation (comme dans le script R, fait deux fois)
    nodes["gene"] = str_remove_dash(nodes["gene"])
    nodes["gene"] = str_remove_trailing_number(nodes["gene"])
    nodes = nodes.groupby(["gene", "category"], as_index=False)["GCPM"].mean()
    nodes["GCPM"] = nodes["GCPM"].fillna(0)

    nodes.columns = ["NodeName", "Type", "GCPM"]

    nodes = nodes[nodes["NodeName"].isin(active_nodes)].copy()

    def _collapse(group):
        gcpm_sum = group["GCPM"].sum()
        node_type = (
            "Multi-resistance" if group["Type"].nunique() > 1 else group["Type"].iloc[0]
        )
        out = group.iloc[[0]].copy()
        out["GCPM"] = gcpm_sum
        out["Type"] = node_type
        return out

    nodes = (
        nodes.groupby("NodeName", group_keys=False).apply(_collapse).reset_index(drop=True)
    )

    return nodes


# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------

def main():
    edges = build_edges()
    edges_final = build_edges_final(edges)

    active_nodes = set(edges_final["gene1"]).union(set(edges_final["gene2"]))
    nodes = build_nodes(active_nodes)

    nodes.to_csv(OUT_NODES, index=False, quoting=0)
    edges_final.to_csv(OUT_EDGES, index=False, quoting=0)

    print(f"Termine. Fichiers generes : {OUT_NODES} et {OUT_EDGES}")


if __name__ == "__main__":
    main()
