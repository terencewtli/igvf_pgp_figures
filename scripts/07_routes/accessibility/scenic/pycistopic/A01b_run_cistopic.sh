#!/bin/bash
#$ -cwd
#$ -o logs/A01b_run_cistopic.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_run_cistopic
#$ -l h_data=4G,h_rt=2:00:00
#$ -pe shared 20
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scenicplus

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}
SAMPLES=$PROJDIR/txt/samples.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CISTOPIC=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/07_routes/accessibility/scenic/pycistopic/A01a_cistopic.py

time python $CISTOPIC $SAMPLE

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
