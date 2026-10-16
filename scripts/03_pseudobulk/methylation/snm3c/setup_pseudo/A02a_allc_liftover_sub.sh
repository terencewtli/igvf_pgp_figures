#!/bin/bash
#$ -cwd
#$ -o logs/A02a_allc_liftover_sub.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02a_allc_liftover_sub
#$ -l h_data=8G,h_rt=12:00:00
#$ -pe shared 6
#$ -t 1-6:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
ANNOTS=$PROJDIR/txt/allc_table/liftover_sub.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

ALLC_PATHS=$PROJDIR/txt/allc_table/liftover_sub/${ANNOT}.txt

OUT=$PROJDIR/allc/liftover_sub/${ANNOT}.allc.tsv.gz

time allcools merge --allc_paths $ALLC_PATHS \
    --output_path $OUT \
    --chrom_size_path $CHROM_SIZES \
    --cpu 40

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
