import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import pickle

import pycisTopic
from pycisTopic.cistopic_class import create_cistopic_object_from_fragments

projdir = '/u/project/cluo/terencew/igvf/2023_YR2/multiome/'
samples = list(np.loadtxt(f'{projdir}/txt/samples.txt', dtype=str))

indir = f'{projdir}/atac/pycistopic/obj'
s = samples[0]

print(s)
with open(f'{indir}/{s}.pkl', 'rb') as fin:
  obj = pickle.load(fin)
  sample_df = pd.DataFrame(index=obj.cell_data.index)
  sample_df['sample'] = s
  obj.add_cell_data(sample_df)

print(obj.cell_data)

for s in samples[1:]:
    print(s)
    with open(f'{indir}/{s}.pkl', 'rb') as fin:
        tmp_obj = pickle.load(fin)
        sample_df = pd.DataFrame(index=tmp_obj.cell_data.index)
        sample_df['sample'] = s
        tmp_obj.add_cell_data(sample_df)

    obj.merge([tmp_obj])

outdir = f'{projdir}/atac/pycistopic/obj'
pickle.dump(obj, open(f'{outdir}/merged.pkl', 'wb'))
