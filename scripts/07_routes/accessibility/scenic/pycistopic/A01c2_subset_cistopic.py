import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import pickle

import pycisTopic

projdir = '/u/project/cluo/terencew/igvf/2023_YR2/multiome/'
samples = list(np.loadtxt(f'{projdir}/txt/samples.txt', dtype=str))

indir = f'{projdir}/atac/pycistopic/obj'
with open(f'{indir}/merged.pkl', 'rb') as fin:
  obj = pickle.load(fin)

meta = pd.read_csv(f'{projdir}/csv/meta/joint/mdata_meta.csv', sep='\t', header=0, index_col=0)
keep_cells = list(meta.index)

subset_obj = obj.subset(cells=keep_cells)

outdir = f'{projdir}/atac/pycistopic/obj'
pickle.dump(subset_obj, open(f'{outdir}/merged.intersect.pkl', 'wb'))
