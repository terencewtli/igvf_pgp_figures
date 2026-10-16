#!/bin/bash
#$ -cwd
#$ -o logs/A01a_merge_bam.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_merge_bam
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-49:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/allc_table/donor_leiden.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

BAM_PATHS=$PROJDIR/txt/bam_paths/donor_leiden/${SAMPLE}.txt
OUT=$PROJDIR/bam/donor_leiden/${SAMPLE}.bam

time samtools merge -@ 50 -b $BAM_PATHS -o $OUT
time samtools index -@ 50 $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
