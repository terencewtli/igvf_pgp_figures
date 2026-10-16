#!/bin/bash
#$ -cwd
#$ -o logs/A01c_bigwig.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_bigwig
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-40:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/rna_cluster_donor.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/rna_cluster_donor/${ANNOT}.CGN-Merge.allc.tsv.gz
OUT=$PROJDIR/bigwig/rna_cluster_donor/${ANNOT}.bigwig

time allcools allc-to-bigwig --allc_path $ALLC \
    --output_prefix $OUT \
    --mc_contexts 'CGN' \
    --chrom_size_path $CHROM_SIZES

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
