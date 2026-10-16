#!/bin/bash
#$ -cwd
#$ -o logs/B01d_dmrs_cgn_ips_cluster.$JOB_ID
#$ -j y
#$ -N B01d_dmrs_cgn_ips_cluster
#$ -l h_data=4G,h_rt=24:00:00
#$ -pe shared 8

echo "Job $JOB_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate allcools

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR

# same call as snmCT/pseudobulk_allc/scripts/dmrs/A05a_ips_cluster.sh, early-iPSC nuclei only, B01c pseudobulks
time methylpy DMRfind \
  --allc-files allc/ips_cluster_cgn/IPS_main.CGN-Merge.allc.tsv.gz allc/ips_cluster_cgn/IPS_alt.CGN-Merge.allc.tsv.gz \
  --samples IPS_main IPS_alt \
  --mc-type 'CGN' \
  --num-procs 8 \
  --min-num-dms 1 \
  --output-prefix dmrs/methylpy/ips_cluster_cgn/
echo "Job $JOB_ID ended on:   " `date`
