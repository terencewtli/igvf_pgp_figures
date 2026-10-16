#!/bin/bash
#$ -cwd
#$ -o logs/B03c_downsample_le_hic.$JOB_ID
#$ -j y
#$ -N B03c_downsample_le_hic
#$ -l h_data=2G,h_rt=8:00:00,h_vmem=256G
#$ -pe shared 4

echo "Job $JOB_ID started on:   " `hostname -s` `date`
source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR
OUTDIR=cooler/ips_cluster_ds
CONVERT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/3c/conversion/A01a_mcool_to_hic.sh

# depth-match iPSC-LE (IPS_main) to iPSC-SE (IPS_alt) for Fig 6F: exact random sample of the 10 kb contacts, seed 1
conda activate allcools
time python -c "
import numpy as np, cooler
from cooltools.api.sample import sample
np.random.seed(1)
target = cooler.Cooler('cooler/ips_cluster/IPS_alt.cool').info['sum']
print('target contacts (IPS_alt):', target)
sample(cooler.Cooler('cooler/ips_cluster/IPS_main.cool'), '$OUTDIR/IPS_main_ds.cool', count=int(target), exact=True)
print('sampled contacts (IPS_main_ds):', cooler.Cooler('$OUTDIR/IPS_main_ds.cool').info['sum'])
"

# same steps as B03a/B03b
conda activate mapping
time cooler zoomify -r 100000,1000000 $OUTDIR/IPS_main_ds.cool
time cooler balance -f -p 4 $OUTDIR/IPS_main_ds.mcool::/resolutions/100000
time bash $CONVERT $PROJDIR/$OUTDIR/IPS_main_ds.mcool $PROJDIR/juicer/ips_cluster_ds/IPS_main_ds.hic
echo "Job $JOB_ID ended on:   " `date`
