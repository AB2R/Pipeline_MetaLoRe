import pandas as pd
import argparse
import os
import re

# ─── Parser GBK → positions génomiques des CDS ────────────────────────────────

def parse_gbk_positions(filepath):
    """
    Lit un fichier GenBank Prodigal (sans LOCUS) et retourne un dict :
        { "contig_1502_1": (3, 356), "contig_1502_2": (384, 647), ... }

    Format Prodigal :
      - DEFINITION  seqnum=1;seqlen=...;seqhdr="contig_1502";...
      - CDS  <start>..<end>  (ou complement(<start>..<end>))
      - /note="ID=1_1;..."  <- numero sequentiel Prodigal
    """
    positions = {}
    seqnum_to_contig = {}
    current_contig = None
    current_cds_start = None
    current_cds_end = None

    with open(filepath) as f:
        for line in f:
            # Nouveau contig : extraire seqhdr="contig_XXXX"
            if line.startswith("DEFINITION"):
                m_hdr = re.search(r'seqhdr="(\S+)', line)
                m_num = re.search(r'seqnum=(\d+)', line)
                if m_hdr and m_num:
                    current_contig = m_hdr.group(1)
                    current_seqnum = m_num.group(1)
                    seqnum_to_contig[current_seqnum] = current_contig
                current_cds_start = None
                current_cds_end = None

            # Ligne CDS : coordonnees genomiques
            cds_match = re.match(r'\s+CDS\s+(?:complement\()?<?(\d+)\.\.>?(\d+)', line)
            if cds_match:
                current_cds_start = int(cds_match.group(1))
                current_cds_end   = int(cds_match.group(2))

            # Ligne /note : ID du CDS (ex: ID=1_18 -> cds_num=18)
            if current_cds_start is not None and '/note=' in line:
                note_match = re.search(r'ID=(\d+)_(\d+);', line)
                if note_match and current_contig:
                    seq_num = note_match.group(1)
                    cds_num = note_match.group(2)
                    contig_name = seqnum_to_contig.get(seq_num, current_contig)
                    cds_key = f"{current_contig}_{cds_num}"
                    positions[cds_key] = (current_cds_start, current_cds_end)
                    current_cds_start = None
                    current_cds_end = None

    print(f"  GBK : {len(positions)} CDS charges")
    return positions
def parse_blast(filepath, source, category, gbk_positions=None):
    records = []
    n_no_pos = 0
    with open(filepath) as f:
        for line in f:
            cols = line.strip().split(";")
            if len(cols) < 12:
                continue
            cds_id = cols[0]                              # ex: contig_1097_18
            contig = "_".join(cds_id.split("_")[:-1])    # ex: contig_1097
            gene_field = cols[1].split("|")

            # Positions génomiques : GBK + offset qstart/qend
            try:
                qstart = int(cols[6])
                qend   = int(cols[7])
            except (ValueError, IndexError):
                n_no_pos += 1
                continue

            if gbk_positions and cds_id in gbk_positions:
                gbk_start, gbk_end = gbk_positions[cds_id]
                if source == "BLAST_mobileOG":
                    # blastp : qstart/qend en acides amines -> convertir en nucleotides (*3)
                    pos_start = gbk_start + (min(qstart, qend) - 1) * 3
                    pos_end   = gbk_start + (max(qstart, qend) - 1) * 3 + 2
                else:
                    # blastn : qstart/qend deja en nucleotides
                    pos_start = gbk_start + min(qstart, qend) - 1
                    pos_end   = gbk_start + max(qstart, qend) - 1
            else:
                pos_start = min(qstart, qend)
                pos_end   = max(qstart, qend)

            if source == "BLAST_mobileOG":
                gene = gene_field[1] if len(gene_field) >= 2 else gene_field[0]
                if gene.upper() == "NA":
                    continue

            elif source == "BLAST_MEGARes":
                gene = gene_field[-1] if len(gene_field) >= 2 else gene_field[0]

            elif source == "BLAST_PlasmidFinder":
                gene = cols[1].split("__")[0]

            else:
                gene = gene_field[0]

            gene = gene.upper()

            records.append({
                "contig":    contig,
                "gene":      gene,
                "source":    source,
                "category":  category,
                "pos_start": pos_start,
                "pos_end":   pos_end,
            })

    if n_no_pos:
        print(f"  {source} : {n_no_pos} hits ignorés (CDS absent du GBK et position manquante)")
    return pd.DataFrame(records)


def parse_abricate(filepath, source, category, gbk_positions=None):
    records = []
    n_no_pos = 0
    with open(filepath) as f:
        for line in f:
            if line.startswith("#") or "START" in line:
                continue
            cols = line.strip().split("\t")
            if len(cols) < 6:
                continue
            cds_id = cols[1]                              # ex: contig_1289_5
            contig = "_".join(cds_id.split("_")[:-1])    # ex: contig_1289
            gene   = cols[5].upper()

            # Positions génomiques : GBK + offset START/END
            try:
                astart = int(cols[2])
                aend   = int(cols[3])
            except (ValueError, IndexError):
                n_no_pos += 1
                continue

            if gbk_positions and cds_id in gbk_positions:
                gbk_start, gbk_end = gbk_positions[cds_id]
                # START/END = positions dans le CDS ; conversion en coordonnées génomiques
                pos_start = gbk_start + min(astart, aend) - 1
                pos_end   = gbk_start + max(astart, aend) - 1
            else:
                pos_start = min(astart, aend)
                pos_end   = max(astart, aend)

            records.append({
                "contig":    contig,
                "gene":      gene,
                "source":    source,
                "category":  category,
                "pos_start": pos_start,
                "pos_end":   pos_end,
            })
    if n_no_pos:
        print(f"  {source} : {n_no_pos} hits ignorés (CDS absent du GBK et position manquante)")
    return pd.DataFrame(records)

# ─── Calcul de distance entre deux hits ────────────────────────────────────────

def genomic_distance(start1, end1, start2, end2):
    """
    Distance inter-intervalles.
    Retourne 0 si chevauchement, sinon le nombre de bases entre les deux gènes.
    """
    if end1 < start2:
        return start2 - end1
    elif end2 < start1:
        return start1 - end2
    else:
        return 0

# ─── Main ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser()

    # BLAST inputs
    parser.add_argument("--blast_megares",       type=str)
    parser.add_argument("--blast_mobileog",      type=str)
    parser.add_argument("--blast_plasmidfinder", type=str)

    # Abricate inputs
    parser.add_argument("--abr_card",      type=str)
    parser.add_argument("--abr_resfinder", type=str)
    parser.add_argument("--abr_ncbiamr",   type=str)

    # GBK pour les positions génomiques des CDS
    parser.add_argument("--gbk", type=str,
                        help="Fichier GenBank Prodigal contenant les positions des CDS sur les contigs")

    # Mobile-OG metadata
    parser.add_argument("--mobileog_db", type=str,
                        help="Fichier CSV mobileOG avec les catégories")

    # Seuil de distance
    parser.add_argument("--max_distance", type=int, default=10000,
                        help="Distance maximale (bp) entre deux gènes pour les considérer co-occurrents (défaut : 10000)")

    parser.add_argument("-o", "--output", default="results", type=str)
    args = parser.parse_args()

    # ── Charger les positions GBK ──
    gbk_positions = None
    if args.gbk:
        print(f"Chargement des positions depuis {args.gbk}…")
        gbk_positions = parse_gbk_positions(args.gbk)

    all_records = []

    # ── BLAST ──
    if args.blast_megares:
        all_records.append(parse_blast(args.blast_megares,       "BLAST_MEGARes",       "BRG",      gbk_positions))
    if args.blast_mobileog:
        all_records.append(parse_blast(args.blast_mobileog,      "BLAST_mobileOG",      "MGE",      gbk_positions))
    if args.blast_plasmidfinder:
        all_records.append(parse_blast(args.blast_plasmidfinder, "BLAST_PlasmidFinder", "Plasmide", gbk_positions))

    # ── Abricate (positions génomiques directes, pas besoin du GBK) ──
    if args.abr_card:
        all_records.append(parse_abricate(args.abr_card,      "Abricate_CARD",          "ARG", gbk_positions))
    if args.abr_resfinder:
        all_records.append(parse_abricate(args.abr_resfinder, "Abricate_ResFinder",     "ARG", gbk_positions))
    if args.abr_ncbiamr:
        all_records.append(parse_abricate(args.abr_ncbiamr,   "Abricate_NCBIAMRFinder", "ARG", gbk_positions))

    # ── Fusionner ──
    df = pd.concat(all_records, ignore_index=True)

    # ── Déduplication : même contig + même gène → fusionner sources, étendre positions ──
    df_dedup = (
        df.groupby(["contig", "gene", "category"])
        .agg(
            source    = ("source",    lambda x: "|".join(sorted(set(x)))),
            pos_start = ("pos_start", "min"),
            pos_end   = ("pos_end",   "max"),
        )
        .reset_index()
    )

    # Sauvegarder tableau complet
    df_dedup.to_csv(f"{args.output}_all_hits.tsv", sep="\t", index=False)
    print(f"Total hits (dédupliqués) : {len(df_dedup)}")

    # ── Jointure avec les catégories mobileOG ──
    if args.mobileog_db:
        mobileog_ref = pd.read_csv(args.mobileog_db, sep=",",
                                   usecols=["Name", "Major mobileOG Category"])
        mobileog_ref.columns = ["gene", "mobileOG_category"]
        mobileog_ref["gene"] = mobileog_ref["gene"].str.upper()
        mobileog_ref = mobileog_ref.drop_duplicates(subset="gene")

        df_dedup = df_dedup.merge(mobileog_ref, on="gene", how="left")
        df_dedup.to_csv(f"{args.output}_all_hits.tsv", sep="\t", index=False)

    # ── Co-occurrences par distance génomique ─────────────────────────────────
    print(f"\nRecherche de co-occurrences (distance ≤ {args.max_distance} bp)…")
    cooccurrences = []

    for contig, hits in df_dedup.groupby("contig"):
        if len(hits) < 2:
            continue

        hits = hits.sort_values("pos_start").reset_index(drop=True)

        for i in range(len(hits)):
            row_i = hits.iloc[i]
            for j in range(i + 1, len(hits)):
                row_j = hits.iloc[j]

                # Optimisation : break si j est déjà trop loin
                if row_j["pos_start"] - row_i["pos_end"] > args.max_distance:
                    break

                dist = genomic_distance(
                    row_i["pos_start"], row_i["pos_end"],
                    row_j["pos_start"], row_j["pos_end"],
                )

                if dist <= args.max_distance:
                    entry = {
                        "contig":      contig,
                        "gene1":       row_i["gene"],
                        "category1":   row_i["category"],
                        "source1":     row_i["source"],
                        "start1":      row_i["pos_start"],
                        "end1":        row_i["pos_end"],
                        "gene2":       row_j["gene"],
                        "category2":   row_j["category"],
                        "source2":     row_j["source"],
                        "start2":      row_j["pos_start"],
                        "end2":        row_j["pos_end"],
                        "distance_bp": dist,
                    }
                    if "mobileOG_category" in df_dedup.columns:
                        entry["mobileOG_cat1"] = row_i.get("mobileOG_category", "")
                        entry["mobileOG_cat2"] = row_j.get("mobileOG_category", "")
                    cooccurrences.append(entry)

    df_coocc = pd.DataFrame(cooccurrences)

    if df_coocc.empty:
        print("Aucune co-occurrence trouvée.")
    else:
        df_coocc.to_csv(f"{args.output}_cooccurrences.tsv", sep="\t", index=False)
        print(f"Co-occurrences trouvées : {len(df_coocc)}")

        # ── Résumé des paires les plus fréquentes ──
        df_coocc["pair"] = df_coocc["gene1"] + " | " + df_coocc["gene2"]
        summary = df_coocc["pair"].value_counts().reset_index()
        summary.columns = ["paire", "count"]
        summary.to_csv(f"{args.output}_cooccurrences_summary.tsv", sep="\t", index=False)
        print(f"\nTop 10 co-occurrences :")
        print(summary.head(10).to_string(index=False))

if __name__ == "__main__":
    main()
