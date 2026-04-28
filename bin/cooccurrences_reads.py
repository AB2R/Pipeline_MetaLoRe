import argparse
from pathlib import Path

def parse_blast(filepath):
    """Format BLAST : col1=contig, col2=gene, col7=start"""
    records = []
    with open(filepath) as f:
        for line in f:
            cols = line.strip().split("\t")
            if len(cols) < 7:
                continue
            contig = cols[0]
            gene = cols[1]
            start = int(cols[6])
            records.append((contig, gene, start))
    return records

def parse_abricate(filepath):
    """Format Arbricate : col2=contig, col3=start, col6=gene"""
    records = []
    with open(filepath) as f:
        for line in f:
            if line.startswith("#") or "START" in line:
                continue
            cols = line.strip().split("\t")
            if len(cols) < 13:
                continue
            contig = cols[1]
            gene = cols[5]
            start = int(cols[2])
            records.append((contig, gene, start))
    return records

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--blast", type=str, nargs="+", help="Fichiers BLAST")
    parser.add_argument("--abricate", type=str, nargs="+", help="Fichiers Abricate")
    args = parser.parse_args()

    records = []

    if args.blast:
        for f in args.blast:
            records.extend(parse_blast(f))

    if args.abricate:
        for f in args.abricate:
            records.extend(parse_abricate(f))

    cooccurrences_list = set()
    for i in range(len(records)):
        contig_i, gene_i, start_i = records[i]
        for j in range(i + 1, len(records)):
            contig_j, gene_j, start_j = records[j]
            if contig_i == contig_j and abs(start_i - start_j) <= 10000:
                cooccurrences_list.add((contig_i, gene_i, start_i, gene_j, start_j))

    with open("cooccurrences_reads.tab", "w") as outfile:
        for entry in cooccurrences_list:
            outfile.write("\t".join(map(str, entry)) + "\n")

if __name__ == "__main__":
    main()
