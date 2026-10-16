import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import os
from concurrent.futures import ProcessPoolExecutor
from tqdm import tqdm

import glob

import sys

contacts_list_path = sys.argv[1]
out = sys.argv[2]

contacts_list = pd.read_csv(contacts_list_path, header=None)[0].values

select = [0, 1, 6, 4, 2, 3, 7, 5, 8]

def process_contacts(tmp_path):
    s = os.path.basename(tmp_path).split('.')[0]
    tmp_contacts = pd.read_csv(tmp_path, sep="\t",header=None)
    tmp_contacts[4] = tmp_contacts[4].fillna('.')
    tmp_contacts[5] = tmp_contacts[5].fillna('.')
    tmp_contacts[6] = tmp_contacts[1] + 1
    tmp_contacts[7] = tmp_contacts[3] + 1
    tmp_contacts[8] = s
    return tmp_contacts[select]

with ProcessPoolExecutor() as pool:
  results = list(tqdm(pool.map(process_contacts, contacts_list),
                        total=len(contacts_list)))

merged = pd.concat(results, ignore_index=True, copy=False)
merged.to_csv(out, sep='\t', header=None, index=None)
