#!/bin/bash
#$ -cwd
#$ -o logs/A01a_merge_fastq.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_merge_fastq
#$ -l h_data=2G,h_rt=2:00:00
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

INDIR=/u/project/cluo/Shared_Datasets/IGVF/202208_Pilot/new_multiome/YS3_Testrun3/Fastqs

# ID=1
ID=$SGE_TASK_ID

ATAC_SAMPLES=$PROJDIR/txt/atac_samples.txt
ATAC_SAMPLE=$(head -${ID} $ATAC_SAMPLES | tail -1)

ATAC_INDIR=$INDIR/ATAC_Fastqs/
ATAC_OUTDIR=$PROJDIR/fastq/atac
time cat ${ATAC_INDIR}/${ATAC_SAMPLE}_*_I1*gz > $ATAC_OUTDIR/${ATAC_SAMPLE}_ATAC_S1_L001_I1_001.fastq.gz
time cat ${ATAC_INDIR}/${ATAC_SAMPLE}_*_R1*gz > $ATAC_OUTDIR/${ATAC_SAMPLE}_ATAC_S1_L001_R1_001.fastq.gz
time cat ${ATAC_INDIR}/${ATAC_SAMPLE}_*_R2*gz > $ATAC_OUTDIR/${ATAC_SAMPLE}_ATAC_S1_L001_R2_001.fastq.gz
time cat ${ATAC_INDIR}/${ATAC_SAMPLE}_*_R3*gz > $ATAC_OUTDIR/${ATAC_SAMPLE}_ATAC_S1_L001_R3_001.fastq.gz

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
