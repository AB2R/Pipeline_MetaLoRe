import argparse
import os
import re

def main():

    ### Part argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", type=str, help='Kraken result input file')
    parser.add_argument("-d", "--database", type=str, help='Path to kraken database')
    parser.add_argument("-o", "--output", type=str, help='Output file read id')

    args = parser.parse_args()

    
    ### Input files taxonomy
    nodes_file = f"{args.database}/nodes.dmp"
    names_file = f"{args.database}/names.dmp"
    #Open nodes files
    parent = {}
    rank = {}
    with open(nodes_file, 'r') as f:
        for line in f:
            parts = [x.strip() for x in line.split('|')]
            taxid = parts[0]
            parent_taxid = parts[1]
            rank_tax = parts[2]
            parent[taxid] = parent_taxid
            rank[taxid] = rank_tax

    #Open names files
    names = {}
    with open(names_file, 'r') as f:
        for line in f:
            parts = [x.strip() for x in line.split('|')]
            taxid = parts[0]
            name_txt = parts[1]
            name_class = parts[3]
            if name_class == "scientific name":
                names[taxid] = name_txt

    
    ### Process
    input_file = args.input
    output_file = args.output

    with open(input_file, 'r') as ifile:
        
        with open(output_file, 'w') as ofile:

            for line in ifile.readlines():

                #Part to collect unclassified
                if line[:-1].split('\t')[0] == "U":
                    ofile.write(line[:-1].split('\t')[1] + ('\n'))
                    continue

                #Part to verify if bacteria is the kingdom tax id
                fields = line.strip().split('\t')
                match = re.search(r'taxid (\d+)', fields[2])
                if match:
                     taxid_str = match.group(1)
                else:
                     continue

                domain = classify_domain_bacteria(get_lineage(taxid_str, parent), rank, names)
                if domain:
                    read_id = line[:-1].split('\t')[1]
                    ofile.write(read_id + ('\n'))

def get_lineage(taxid, parent):
    lineage = []
    current = taxid
    while current != "1" and current in parent:
        lineage.append(current)
        current = parent[current]
    lineage.append("1")  # Root
    return lineage
    
def classify_domain_bacteria(lineage, rank, names):
    for taxid in lineage:
        if names.get(taxid) == "Bacteria":
             return True

if __name__ == "__main__":
    main()
