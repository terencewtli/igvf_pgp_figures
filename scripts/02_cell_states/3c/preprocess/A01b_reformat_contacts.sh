#!/bin/bash
#$ -cwd
#$ -o logs/A01b_reformat_contacts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_reformat_contacts
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-284:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate fasthigashi

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/higashi/
cd $PROJDIR

OUTDIR=$PROJDIR/new_contacts/

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))
CONTACTS=$PROJDIR/txt/batch/contacts/${BATCH}.txt

time for CONTACT in $(cat $CONTACTS);
do
  TMP=${CONTACT#*mapping_bismark\/}
  NUCLEUS=${TMP%\/pairs.tsv}
  OUT=$PROJDIR/new_contacts/${NUCLEUS}.contacts.txt
  cut -f1-4 $CONTACT > $OUT
done

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
