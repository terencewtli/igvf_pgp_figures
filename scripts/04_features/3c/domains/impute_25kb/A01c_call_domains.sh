#!/bin/bash
#$ -cwd
#$ -o logs/A01c_call_domains.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_call_domains
#$ -l h_data=4G,h_rt=8:00:00
#$ -pe shared 12
#$ -t 1-285:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))
CELL_TABLE=$PROJDIR/csv/imputed/25K/batch/${BATCH}.csv
OUT=$PROJDIR/domain/imputed_25K/batch/${BATCH}/

DOMAIN="hicluster domain \
            --cell_table_path $CELL_TABLE \
            --output_prefix $OUT \
            --resolution 25000 \
            --window_size 10 \
            --cpu 20"

time $DOMAIN

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
