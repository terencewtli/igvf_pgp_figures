#!/bin/bash
#$ -cwd
#$ -o logs/A01c_mcool_to_hic_liftover.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_mcool_to_hic_liftover
#$ -l h_data=2G,h_rt=4:00:00,h_vmem=256G
#$ -pe shared 4
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
DESIGNS=$PROJDIR/txt/liftover.txt
DESIGN=$(head -${ID} $DESIGNS | tail -1)

INDIR=/u/project/cluo_scratch/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
COOLER=$INDIR/merged_contacts/cooler/liftover/${DESIGN}.mcool
HIC=$INDIR/merged_contacts/juicer/liftover/${DESIGN}.hic

CONVERT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/3c/conversion/A01a_mcool_to_hic.sh

time bash $CONVERT $COOLER $HIC

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
