import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import anndata
import scanpy as sc

from pycisTopic.cistopic_class import create_cistopic_object_from_fragments

import pyranges as pr
import pickle

import sys

s = sys.argv[1]

projdir = '/u/project/cluo/terencew/igvf/2023_YR2/multiome/'

###
peaks_path = f'{projdir}/atac/peaks/archr/clusters/coarse_v6.cistopic.bed'
peaks = pr.read_bed(peaks_path)

###
indir = f'{projdir}/atac/fragments/ambimux/wgs/header'
frag_path = f'{indir}/{s}.fragments.tsv.gz'

###
atac = sc.read_h5ad(f'{projdir}/h5ad/atac/processed/archr/intersect_rna_reindex_small.h5ad')
tmp_atac = atac[atac.obs['sample'] == s]
valid_bcs = tmp_atac.obs['barcode']

###
blacklist = '/u/project/cluo/terencew/reference/hg38/bed/hg38-blacklist.v2.bed'
metrics=None

print(frag_path, peaks_path, blacklist, metrics, valid_bcs.shape)

###
cistopic = create_cistopic_object_from_fragments(frag_path, peaks_path, blacklist,
                                                 metrics, valid_bcs, n_cpu=20)

outdir = f'{projdir}/atac/pycistopic/'

pickle.dump(
    cistopic,
    open(f'{outdir}/{s}.pkl', 'wb')
)
