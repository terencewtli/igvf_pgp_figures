#!/bin/bash
#$ -cwd
#$ -o logs/B00b_run_one_notebook.$JOB_ID
#$ -j y
#$ -N B00b_run_one_notebook
#$ -l h_data=8G,h_rt=4:00:00
#$ -pe shared 4

# usage: qsub scripts/qsub/B00b_run_one_notebook.sh <notebook name without .ipynb>
echo "Job $JOB_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate scFates

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR/ipynb

NB=$1
echo $NB
time jupyter nbconvert --to notebook --execute --inplace --ExecutePreprocessor.timeout=-1 $NB.ipynb
echo "Job $JOB_ID ended on:   " `date`
