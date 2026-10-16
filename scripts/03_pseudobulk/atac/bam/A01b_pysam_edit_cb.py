import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

import pysam
from collections import defaultdict
import sys

s = sys.argv[1]

###
projdir = '/u/project/cluo/terencew/igvf/2023_YR2/multiome'
indir = f'{projdir}/bam/sample'

###
bam = pysam.AlignmentFile(f'{indir}/gex/{s}.bam')
out = pysam.AlignmentFile(f'{indir}/gex/{s}.cb.bam', 'wb',
                          header=bam.header, threads=20)

for read in bam.fetch():
    cb = read.get_tag('CB')
    read.set_tag('CB', f'{cb}_{s}')
    out.write(read)
out.close()

###
bam = pysam.AlignmentFile(f'{indir}/atac/{s}.bam')
out = pysam.AlignmentFile(f'{indir}/atac/{s}.cb.bam', 'wb',
                          header=bam.header, threads=20)

for read in bam.fetch():
    cb = read.get_tag('CB')
    read.set_tag('CB', f'{cb}_{s}')
    out.write(read)
out.close()

###
bam.close()
