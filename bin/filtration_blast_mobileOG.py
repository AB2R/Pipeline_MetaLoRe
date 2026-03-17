import argparse
from pathlib import Path

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str, help="Blast with Megares results input file")

    args = parser.parse_args()

    input_path = Path(args.input)
    output_file = Path(f"{input_path.stem}_mobileOG_filtered{input_path.suffix}")

    genes_list = set()

    with open(input_path) as infile, open(output_file, "w") as outfile:
        for line in infile:
            cols = line.strip().split("\t")

            if len(cols) > 2:
                pident = float(cols[2])
                if pident <= 90:
                    continue

                length_align = float(cols[3])
                if length_align < 100:
                    continue

                parts = cols[1].split("|")

                gene_name = parts[1]
                if gene_name in genes_list:
                    continue

            genes_list.add(gene_name)
            outfile.write(line)

if __name__ == "__main__":
    main()
