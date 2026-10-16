#!/bin/bash
#$ -cwd
#$ -o logs/A01a_rna_cluster_donor_bigwig.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_rna_cluster_donor_bigwig
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-40:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate monopogen

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/bam_table/rna_coarse_donor.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

BAM=$PROJDIR/bam/rna_coarse_donor/atac/${SAMPLE}.bam
OUT=$PROJDIR/bigwig/rna_coarse_donor/${SAMPLE}.bw

time bamCoverage -b $BAM \
  -o $OUT \
  --normalizeUsing RPGC \
  --effectiveGenomeSize 2913022398 \
  --extendReads \
  --centerReads \
  --binSize 10 \
  --ignoreDuplicates \
  -p 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
