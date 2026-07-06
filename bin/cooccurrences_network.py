import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
import argparse
from matplotlib.patches import FancyArrowPatch
from matplotlib.lines import Line2D

parser = argparse.ArgumentParser(description="Réseau de co-occurrences de gènes")
parser.add_argument("--nodes", required=True, help="Fichier CSV des nœuds")
parser.add_argument("--edges", required=True, help="Fichier CSV des arêtes")
args = parser.parse_args()

nodes = pd.read_csv(args.nodes)
edges = pd.read_csv(args.edges)

NODE_SCALE = 1
NODE_OFFSET = 10
EDGE_SCALE = 3

G = nx.MultiGraph()

for _, row in nodes.iterrows():
    G.add_node(row["NodeName"], type=row["Type"], GCPM=row["GCPM"])

for _, row in edges.iterrows():
    G.add_edge(row["gene1"], row["gene2"],
               weight=row["count"],
               filiere=row["Lm"])

pos = nx.spring_layout(G, seed=42, k=2)

type_colors = {"ARG": "red", "BRG": "lightblue", "MGE": "gray", "Multi-resistance": "green"}
node_colors = [type_colors.get(G.nodes[n]["type"], "gray") for n in G.nodes]
node_sizes = [max((G.nodes[n]["GCPM"] * NODE_SCALE) + NODE_OFFSET, 50) for n in G.nodes]

filiere_colors = {"Seafood": "#87B9D5", "Vegetable": "#479B7B", "Pork": "#EB967F"}
filiere_order = ["Seafood", "Vegetable", "Pork"]

fig, ax = plt.subplots(figsize=(14, 14))

# 1. Arêtes en premier
for filiere in filiere_order:
    z = filiere_order.index(filiere) + 1
    for u, v, key, d in G.edges(data=True, keys=True):
        if str(d.get("filiere", "")).strip() != filiere:
            continue
        color = filiere_colors[filiere]
        width = max(np.log1p(d["weight"]) * EDGE_SCALE, 0.5)
        x1, y1 = pos[u]
        x2, y2 = pos[v]
        if filiere == "Seafood":
            rad = 0.1 + (key % 3) * 0.15
        elif filiere == "Vegetable":
            rad = -(0.2 + (key % 3) * 0.15)
        else:  # Pork
            rad = 0.4 + (key % 3) * 0.15
        ax.add_patch(FancyArrowPatch(
            (x1, y1), (x2, y2),
            connectionstyle=f"arc3,rad={rad}",
            color=color,
            linewidth=width,
            arrowstyle="-",
            zorder=z,
            transform=ax.transData
        ))

# 2. Nœuds par-dessus
nc = nx.draw_networkx_nodes(
    G, pos, ax=ax,
    node_color=node_colors,
    node_size=node_sizes,
    edgecolors="black",
    linewidths=1.5
)
nc.set_zorder(10)  # ← appliqué sur la collection retournée

# 3. Labels
for node, (x, y) in pos.items():
    size = max((G.nodes[node]["GCPM"] * NODE_SCALE) + NODE_OFFSET, 50)
    # Convertir le rayon du nœud (points) en coordonnées du graphe
    radius_points = np.sqrt(size / np.pi)  # rayon en points
    # Transformer 1 point en coordonnées data
    pixel_per_point = fig.dpi / 72.0
    radius_pixels = radius_points * pixel_per_point
    # Convertir pixels en coordonnées data
    inv = ax.transData.inverted()
    x0, y0 = inv.transform(ax.transData.transform((x, y)))
    x1, y1 = inv.transform(ax.transData.transform((x, y)) + np.array([0, radius_pixels]))
    offset = (y1 - y0) + 0.05  # rayon + petit padding
    ax.text(x, y + offset, node,
            fontsize=16, fontweight='bold',
            ha='center', va='bottom', zorder=11)

legend_elements = [
    Line2D([0], [0], marker='o', color='w', label='ARGs', markerfacecolor='red',
           markeredgecolor='black', markersize=16),
    Line2D([0], [0], marker='o', color='w', label='BRGs', markerfacecolor='lightblue',
           markeredgecolor='black', markersize=16),
    Line2D([0], [0], marker='o', color='w', label='MGEs', markerfacecolor='gray',
           markeredgecolor='black', markersize=16),
    Line2D([0], [0], marker='o', color='w', label='Multi-resistance', markerfacecolor='green',
           markeredgecolor='black', markersize=16),
    Line2D([0], [0], color='#EB967F', lw=2, label='Pork'),
    Line2D([0], [0], color='#479B7B', lw=2, label='Vegetable'),
    Line2D([0], [0], color='#87B9D5', lw=2, label='Seafood'),
]

ax.legend(handles=legend_elements, loc='upper right', fontsize=14)
ax.axis("off")
plt.tight_layout()
plt.savefig("reseau_cooccurrence_LR_gcpm.png", dpi=300, bbox_inches="tight")
plt.show()
