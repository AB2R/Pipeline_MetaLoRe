import argparse
from pathlib import Path

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str, help="Blast with Megares results input file")

    args = parser.parse_args()

    input_path = Path(args.input)
    output_file = Path(f"{input_path.stem}_megares_filtered{input_path.suffix}")

    genes_list = set()

    with open(input_path) as infile, open(output_file, "w") as outfile:
        for line in infile:
            cols = line.strip().split("\t")

            if len(cols) > 1:
                parts = cols[1].split("|")

                if parts[1] in ["Drugs", "Metals"] \
                    or parts[2] in ["Drug_and_metal_resistance"]:
                        continue

                gene_name = parts[4]
                if gene_name in genes_list:
                    continue

            genes_list.add(gene_name)
            outfile.write(line)

if __name__ == "__main__":
    main()
