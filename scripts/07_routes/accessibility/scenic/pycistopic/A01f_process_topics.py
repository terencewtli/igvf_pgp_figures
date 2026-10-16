import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pickle
import os

from pycisTopic.topic_binarization import binarize_topics
from pycisTopic.topic_qc import compute_topic_metrics, plot_topic_qc, topic_annotation

from pycisTopic.clust_vis import (
    find_clusters,
    run_umap,
    run_tsne,
    plot_metadata,
    plot_topic,
    cell_topic_heatmap
)

from pycisTopic.topic_binarization import binarize_topics
from pycisTopic.topic_qc import compute_topic_metrics, plot_topic_qc, topic_annotation
import matplotlib.pyplot as plt
from pycisTopic.utils import fig2img

from pycisTopic.diff_features import (
    impute_accessibility,
    normalize_scores,
    find_highly_variable_features,
    find_diff_features
)
from pycisTopic.loom import export_region_accessibility_to_loom, export_gene_activity_to_loom

import pyranges as pr
from pycisTopic.gene_activity import get_gene_activity
import sys

projdir = '/u/project/cluo/terencew/igvf/2023_YR2/multiome/'
samples = list(np.loadtxt(f'{projdir}/txt/samples.txt', dtype=str))

indir = f'{projdir}/atac/pycistopic/models'
n = 50
with open(f'{indir}/{n}_topics.model.intersect.pkl', 'rb') as fin:
  model = pickle.load(fin)

indir = f'{projdir}/atac/pycistopic/obj'
with open(f'{indir}/merged.pkl', 'rb') as fin:
  cistopic_obj = pickle.load(fin)

clusters = pd.read_csv(f'{projdir}/csv/clusters/rna_leiden_v6.csv',
                       sep='\t', header=0, index_col=0)

cistopic_obj.add_cell_data(clusters[['clusters_v6']])

###
print('running regions bin topics')
region_bin_topics_top_3k = binarize_topics(
           cistopic_obj, method='ntop', ntop = 3000,
               plot=True, num_columns=5)

print(cistopic_obj)

region_bin_topics_otsu = binarize_topics(
            cistopic_obj, method='otsu',
                plot=False, num_columns=5
                )

binarized_cell_topic = binarize_topics(
            cistopic_obj,
            target='cell',
            method='li',
            plot=False,
            num_columns=5, nbins=100)

topic_annot = topic_annotation(
    cistopic_obj,
    annot_var='clusters_v6',
    binarized_cell_topic=binarized_cell_topic,
    general_topic_thr = 0.2
)

imputed_acc_obj = impute_accessibility(
            cistopic_obj,
            selected_cells=None,
            selected_regions=None,
            scale_factor=10**6
            )

normalized_imputed_acc_obj = normalize_scores(imputed_acc_obj, scale_factor=10**4)

variable_regions = find_highly_variable_features(
    normalized_imputed_acc_obj,
    min_disp = 0.05,
    min_mean = 0.0125,
    max_mean = 3,
    max_disp = np.inf,
    n_bins=20,
    n_top_features=None,
    plot=True
)

markers_dict= find_diff_features(
    cistopic_obj,
    imputed_acc_obj,
    variable='clusters_v6',
    var_features=variable_regions,
    contrasts=None,
    adjpval_thr=0.05,
    log2fc_thr=np.log2(1.5),
    n_cpu=5,
    _temp_dir='/u/project/cluo_scratch/terencew/tmp/scenic/markers',
    split_pattern = '-'
)

out_dir = f'{projdir}/atac/pycistopic/final_model/'
os.makedirs(os.path.join(out_dir, "region_sets"), exist_ok = True)
os.makedirs(os.path.join(out_dir, "region_sets", "Topics_otsu"), exist_ok = True)
os.makedirs(os.path.join(out_dir, "region_sets", "Topics_top_3k"), exist_ok = True)
os.makedirs(os.path.join(out_dir, "region_sets", "DARs_cell_type"), exist_ok = True)

for topic in region_bin_topics_otsu:
    region_names_to_coordinates(
        region_bin_topics_otsu[topic].index
    ).sort_values(
        ["Chromosome", "Start", "End"]
    ).to_csv(
        os.path.join(out_dir, "region_sets", "Topics_otsu", f"{topic}.bed"),
        sep = "\t",
        header = False, index = False
    )

for topic in region_bin_topics_top_3k:
    region_names_to_coordinates(
        region_bin_topics_top_3k[topic].index
    ).sort_values(
        ["Chromosome", "Start", "End"]
    ).to_csv(
        os.path.join(out_dir, "region_sets", "Topics_top_3k", f"{topic}.bed"),
        sep = "\t",
        header = False, index = False
    )

for cell_type in markers_dict:
    region_names_to_coordinates(
        markers_dict[cell_type].index
    ).sort_values(
        ["Chromosome", "Start", "End"]
    ).to_csv(
        os.path.join(out_dir, "region_sets", "DARs_cell_type", f"{cell_type}.bed"),
        sep = "\t",
        header = False, index = False
    )

cluster_markers = {'clusters_v6': markers_dict}
os.makedirs(os.path.join(out_dir, "loom"), exist_ok=True)

export_region_accessibility_to_loom(
    accessibility_matrix = imputed_acc_obj,
    cistopic_obj = cistopic_obj,
    binarized_topic_region = region_bin_topics_otsu,
    binarized_cell_topic = binarized_cell_topic,
    selected_cells = cistopic_obj.projections['cell']['UMAP'].index.tolist(),
    out_fname = os.path.join(out_dir, "loom", "intersect_rna.loom"),
    cluster_annotation = ['Seurat_cell_type'],
    cluster_markers = cluster_markers,
    tree_structure = ('10x_multiome_brain', 'pycisTopic', 'noDBL_all'),
    title = 'Tutorial - Region accessibility all',
    nomenclature = "hg38",
    split_pattern = '-'
)
