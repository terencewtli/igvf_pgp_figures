#!/bin/bash
#$ -cwd
#$ -o logs/A01a_split_contacts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_split_contacts
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 2
#$ -t 1-28426:1000

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate fasthigashi

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/higashi/
cd $PROJDIR

IN=$PROJDIR/txt/contact_paths.txt
OUT=$PROJDIR/txt/batch/contacts/

time split -d -a3 -l 100 --additional-suffix=.txt $IN $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
