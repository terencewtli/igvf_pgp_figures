#!/bin/bash
#$ -cwd
#$ -o logs/A01b_merge_ips_cluster_donor.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_merge_ips_cluster_donor
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-8:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate hiclusterv2

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster
cd $PROJDIR

# ID=7
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/ips_cluster_donor.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

INDIR=$PROJDIR/old_hicluster/imputed_matrix/10kb_resolution/merged/ips_cluster_donor

INPUT=$INDIR/$ANNOT/$ANNOT
OUT=$INDIR/$ANNOT/${ANNOT}_merged
mkdir -p $OUT

time hicluster loop-mergechr \
  --inprefix $INPUT \
  --outprefix $OUT \
  --chrom_file $CHROM_SIZES

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
