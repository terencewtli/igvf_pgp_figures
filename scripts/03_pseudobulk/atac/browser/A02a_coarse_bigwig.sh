#!/bin/bash
#$ -cwd
#$ -o logs/A02a_coarse_bigwig.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02a_coarse_bigwig
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate monopogen

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/clusters/coarse.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

BAM=$PROJDIR/bam/rna_coarse/atac/${SAMPLE}.bam
OUT=$PROJDIR/bigwig/rna_coarse/${SAMPLE}.bw

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
