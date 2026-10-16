#!/bin/bash
#$ -cwd
#$ -o logs/A01c_merge_contacts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_merge_contacts
#$ -l h_data=100G,h_rt=2:00:00
#$ -pe shared 1
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scFates

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/donor_time.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CONTACT_LIST=$PROJDIR/txt/pseudobulk/donor_time/${SAMPLE}.txt
OUT=$PROJDIR/merged_contacts/raw/donor_time/${SAMPLE}.bedpe.gz

MERGE=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/3c/submit/A01b_merge_contacts.py

time python $MERGE $CONTACT_LIST $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
