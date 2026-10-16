#!/bin/bash
#$ -cwd
#$ -o logs/A01f_merge_principal_contacts.$JOB_ID
#$ -j y
#$ -N A01f_merge_principal_contacts
#$ -l h_data=8G,h_rt=20:00:00
#$ -pe shared 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scFates

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

MERGE=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/3c/submit/A01e_merge_principal_contacts.py

time python $MERGE

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
