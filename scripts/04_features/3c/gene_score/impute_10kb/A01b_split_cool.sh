#!/bin/bash
#$ -cwd
#$ -o logs/A01b_split_cool.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_split_cool
#$ -l h_data=8G,h_rt=12:00:00
#$ -pe shared 2
#$ -t 1-143:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

IN=$PROJDIR/csv/imputed/10K_cool_paths.csv
OUT=$PROJDIR/csv/imputed/10K/batch/
split -d -a3 -l 100 --additional-suffix=.csv $IN $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
