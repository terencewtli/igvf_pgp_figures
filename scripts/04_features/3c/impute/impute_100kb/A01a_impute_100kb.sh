#!/bin/bash
#$ -cwd
#$ -o logs/A01a_impute_100kb.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_impute_100kb
#$ -l h_data=2G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-285:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

INDIR=$PROJDIR/snkmk_imputed/100K/
SNAKE=$INDIR/snakemake_cmd.txt

# ID=1
ID=$SGE_TASK_ID
IDX=$((ID - 1))

TMP_SNAKE=$INDIR/chunk${IDX}/test_snakemake.txt
head -${ID} $SNAKE | tail -1 > $TMP_SNAKE

time bash $TMP_SNAKE

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
