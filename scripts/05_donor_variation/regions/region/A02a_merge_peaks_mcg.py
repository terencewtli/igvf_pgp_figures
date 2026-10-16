import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import glob
import os

from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor, as_completed
from tqdm import tqdm

import sys

tmp_paths = sys.argv[1]
outdir = sys.argv[2]
batch = sys.argv[3]

final_paths = pd.read_csv(tmp_paths, header=None)[0]

def read_mc(s):
    peaks_mc = pd.read_csv(s , sep='\t', usecols=[15])
    return peaks_mc

with ProcessPoolExecutor() as executor:
    mc_results = list(tqdm(executor.map(read_mc, final_paths), total=len(final_paths)))

def read_cov(s):
    peaks_cov = pd.read_csv(s , sep='\t', usecols=[16])
    return peaks_cov

with ProcessPoolExecutor() as executor:
    cov_results = list(tqdm(executor.map(read_cov, final_paths), total=len(final_paths)))

merged_mc = pd.concat(mc_results, axis=1)
merged_mc.columns = final_paths

merged_cov = pd.concat(cov_results, axis=1)
merged_cov.columns = final_paths

merged_mc.to_csv(f'{outdir}/{batch}.mc.csv.gz', sep='\t')
merged_cov.to_csv(f'{outdir}/{batch}.cov.csv.gz', sep='\t')
