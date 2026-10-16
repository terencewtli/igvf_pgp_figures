#!/bin/bash
#$ -cwd
#$ -o logs/B03b_mcool_to_hic_ips_cluster.$JOB_ID.$TASK_ID
#$ -j y
#$ -N B03b_mcool_to_hic_ips_cluster
#$ -l h_data=2G,h_rt=8:00:00,h_vmem=256G
#$ -pe shared 4
#$ -t 1-2
#$ -tc 2

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate mapping

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLE=$(head -${ID} txt/contacts/ips_cluster.txt | tail -1)
CONVERT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/3c/conversion/A01a_mcool_to_hic.sh

# KR-normalized .hic for the Fig 6F contact map, as in 03_pseudobulk/3c/conversion/old_all_nuclei/A01d_mcool_to_hic_ips_cluster.sh
time bash $CONVERT $PROJDIR/cooler/ips_cluster/${SAMPLE}.mcool $PROJDIR/juicer/ips_cluster/${SAMPLE}.hic
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date`
