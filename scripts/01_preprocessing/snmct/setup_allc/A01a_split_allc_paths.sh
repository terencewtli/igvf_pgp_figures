#!/bin/bash
#$ -cwd
#$ -o logs/A01a_split_allc_paths.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_split_allc_paths
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 4
#$ -t 1-3:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/mc/
cd $PROJDIR

IN=$PROJDIR/txt/allc_paths.txt
OUT=$PROJDIR/txt/batch/allc/

split -d -a3 -l 100 --additional-suffix=.txt $IN $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
