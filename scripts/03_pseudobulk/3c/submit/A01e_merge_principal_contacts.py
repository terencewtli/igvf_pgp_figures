import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import os
from concurrent.futures import ProcessPoolExecutor
from tqdm import tqdm

import glob

print ('merging contacts')

indir = '/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/rmbkl'
contacts_list = glob.glob(f'{indir}/*.gz')
out = '/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic/csv/submit/pgp_snm3c_chromatin_contacts.tsv.gz'

select = [0, 1, 6, 4, 2, 3, 7, 5, 8]

def process_contacts(tmp_path):
    s = os.path.basename(tmp_path).split('.')[0]
    tmp_contacts = pd.read_csv(tmp_path, sep='\t', header=None)
    tmp_contacts[4] = tmp_contacts[4].fillna('.')
    tmp_contacts[5] = tmp_contacts[5].fillna('.')
    tmp_contacts[6] = tmp_contacts[1] + 1
    tmp_contacts[7] = tmp_contacts[3] + 1
    tmp_contacts[8] = s
    return tmp_contacts[select]

chunk_size = 100
chunks = [contacts_list[i:i+chunk_size] for i in range(0, len(contacts_list), chunk_size)]

# 
#     merged_chunk.to_csv(out, sep='\t', header=None, index=False,
#     del results, merged_chunk
# 

out_tmp = out.replace('.tsv.gz', '.tsv')

first = True
for chunk in tqdm(chunks):
  with ProcessPoolExecutor() as pool:
    results = list(pool.map(process_contacts, chunk))
  merged_chunk = pd.concat(results, ignore_index=True, copy=False)
  merged_chunk.to_csv(out_tmp, sep='\t', header=None, index=False,
                                    mode='w' if first else 'a')
  first = False
  del results, merged_chunk

# compress at the end
# os.system(f'pigz -p 8 {out_tmp}')  # parallel gzip, much faster
