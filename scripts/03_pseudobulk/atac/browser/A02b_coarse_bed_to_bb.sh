#!/bin/bash
#$ -cwd
#$ -o logs/A02b_coarse_bed_to_bb.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02b_coarse_bed_to_bb
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-30:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/bam_table/rna_cluster.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

BED=$PROJDIR/atac/peaks/chromhmm/cluster/${SAMPLE}.bed
TMP_BED=$PROJDIR/tmp/${SAMPLE}.bed
LC_COLLATE=C sort -k1,1 -k2,2n $BED | cut -f1-3 > $TMP_BED

CONVERT=/u/project/cluo/terencew/programs/kentsrc/utils/bedToBigBed
CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.chromsizes
BIGBED=$PROJDIR/bed/peaks/chromhmm/bigbed/${SAMPLE}.bigBed

time $CONVERT $TMP_BED $CHROM_SIZES $BIGBED

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
