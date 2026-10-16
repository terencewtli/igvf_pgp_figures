#!/bin/bash
#$ -cwd
#$ -o logs/A01d_mcool_to_hic_ips_cluster.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_mcool_to_hic_ips_cluster
#$ -l h_data=2G,h_rt=4:00:00,h_vmem=256G
#$ -pe shared 4
#$ -t 1-2:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
DESIGNS=$PROJDIR/txt/ips_cluster.txt
DESIGN=$(head -${ID} $DESIGNS | tail -1)

INDIR=/u/project/cluo_scratch/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
COOLER=$INDIR/merged_contacts/cooler/ips_cluster/${DESIGN}.mcool
HIC=$INDIR/merged_contacts/juicer/ips_cluster/${DESIGN}.hic

CONVERT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/3c/conversion/A01a_mcool_to_hic.sh

time bash $CONVERT $COOLER $HIC

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
