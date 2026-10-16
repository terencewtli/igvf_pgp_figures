#!/bin/bash
#$ -cwd
#$ -o logs/B04a_great_diff_boundaries.$JOB_ID
#$ -j y
#$ -N B04a_great_diff_boundaries
#$ -l h_data=8G,h_rt=16:00:00
#$ -pe shared 4

echo "Job $JOB_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate seacells

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR

# same GREAT call as 09_ipsc_subtypes/great/old_all_nuclei/A01b_great_main_alt.sh, on early-iPSC differential boundary bins (bed from early_ipsc/R03a)
GREAT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/09_ipsc_subtypes/great/A01a_run_great.py
time python $GREAT bed/ips_cluster_diff_bins.bed csv/great_ips_cluster_diff_bins.csv
echo "Job $JOB_ID ended on:   " `date`
