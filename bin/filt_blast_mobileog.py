import argparse
from pathlib import Path

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str, help="Blast with Mobileog results input file")

    args = parser.parse_args()

    input_path = Path(args.input)
    output_file = Path(f"{input_path.stem}_filtered{input_path.suffix}")

    best_hits = {}

    with open(input_path) as infile, open(output_file, "w") as outfile:
        for line in infile:
            cols = line.strip().split("\t")

            if len(cols) > 2:
                pident = float(cols[2])
                if pident <= 80:
                    continue

                length_align = float(cols[3])
                if length_align < 100:
                    continue

                pcov = float(cols[13])
                if pcov < 60:
                    continue

            contig = cols[0]
            start  = cols[6]
            end    = cols[7]
            evalue = float(cols[10])
            pident = float(cols[2])
            bitscore = float(cols[11])

            key = (contig, start, end)
            if key not in best_hits:
                best_hits[key] = (evalue, pident, bitscore, line)
            else:
                best_evalue, best_pident, best_bitscore, _ = best_hits[key]
                if (evalue < best_evalue or
                   (evalue == best_evalue and pident > best_pident) or
                   (evalue == best_evalue and pident == best_pident and bitscore > best_bitscore)):
                    best_hits[key] = (evalue, pident, bitscore, line)

    with open(output_file, "w") as outfile:
        for _, _, _, line in best_hits.values():
            outfile.write(line)

if __name__ == "__main__":
    main()
