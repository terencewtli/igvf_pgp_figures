#!/bin/bash
#$ -cwd
#$ -o logs/A01b_great_main_alt.$JOB_ID
#$ -j y
#$ -N A01b_great_main_alt
#$ -l h_data=2G,h_rt=16:00:00
#$ -pe shared 4

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate seacells

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster
cd $PROJDIR

GREAT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/09_ipsc_subtypes/great/A01a_run_great.py

BOUNDARIES=$PROJDIR/bed/boundaries/ips_alt.bed
OUT=$PROJDIR/csv/great/ips_alt.csv
time python $GREAT $BOUNDARIES $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
