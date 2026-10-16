#!/bin/bash
#$ -cwd
#$ -o logs/A01e_run_cistopic_model_by_topics.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01e_run_cistopic_model_by_topics
#$ -l h_data=4G,h_rt=6:00:00
#$ -pe shared 20
#$ -t 1-30:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scenicplus

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}
IDX=$((ID - 1))

TOPICS=($(seq 10 10 300))
N_TOPICS=${TOPICS[$IDX]}

echo $N_TOPICS

CISTOPIC=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/07_routes/accessibility/scenic/pycistopic/A01d_run_cistopic_model.py

time python $CISTOPIC $N_TOPICS

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
