#!/bin/bash
#$ -cwd
#$ -o logs/A01a_split_contacts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_split_contacts
#$ -l h_data=1G,h_rt=4:00:00
#$ -pe shared 8
#$ -t 1-3:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster
cd $PROJDIR

IN=$PROJDIR/csv/contacts/contact_table.csv
OUT=$PROJDIR/csv/contacts/batch/
split -d -a3 -l 100 --additional-suffix=.csv $IN $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
