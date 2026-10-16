import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pickle

import pycisTopic
from pycisTopic.cistopic_class import create_cistopic_object_from_fragments
from pycisTopic.lda_models import run_cgs_models_mallet
import os

import sys

###
n_topics = int(sys.argv[1])

projdir = '/u/project/cluo/terencew/igvf/2023_YR2/multiome/'
samples = list(np.loadtxt(f'{projdir}/txt/samples.txt', dtype=str))

###
print('loading cistopic object')
indir = f'{projdir}/atac/pycistopic/obj'
with open(f'{indir}/merged.intersect.pkl', 'rb') as fin:
  cistopic_obj = pickle.load(fin)

###

print('runnning LDA')
os.environ['MALLET_MEMORY'] = '200G'
mallet_path = '/u/project/cluo/terencew/programs/Mallet-202108/bin/mallet'

models = run_cgs_models_mallet(
    cistopic_obj,
    n_topics=[n_topics],
    n_cpu=5,
    n_iter=200,
    random_state=0,
    alpha=50,
    alpha_by_topic=True,
    eta=0.1,
    eta_by_topic=False,
    tmp_path="/u/project/cluo_scratch/terencew/tmp/scenic/",
    save_path="/u/project/cluo_scratch/terencew/tmp/scenic/",
    reuse_corpus=False,
    mallet_path=mallet_path
)

outdir = f'{projdir}/atac/pycistopic/models'
outfile = f'{outdir}/{n_topics}_topics.model.intersect.pkl'

with open(outfile, 'wb') as f:
  pickle.dump(models, f)
