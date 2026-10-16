import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import greatpy
import sys

regions = sys.argv[1]
out = sys.argv[2]

print(regions)
print(out)

chrom_sizes = '/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes'
regdom = '/u/project/cluo/terencew/reference/hg38/great/hg38.regdom.bed'
ontologies = '/u/project/cluo/terencew/programs/greatpy/data/human/ontologies.csv'

res = greatpy.tl.enrichment(
    test_file=regions,
    regdom_file=regdom,
    chr_size_file=chrom_sizes,
    annotation_file=ontologies,
    binom=True,
    hypergeom=False)

res.to_csv(out, sep='\t')
