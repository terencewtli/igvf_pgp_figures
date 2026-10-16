#!/bin/bash
#$ -cwd
#$ -o logs/A01b_split_cool.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_split_cool
#$ -l h_data=4G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-257:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

IN=$PROJDIR/csv/imputed/25K/cell_table.csv
OUT=$PROJDIR/csv/imputed/25K/batch/

split -d -a3 -l 100 --additional-suffix=.csv $IN $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
