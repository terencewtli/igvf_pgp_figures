#!/bin/bash
#$ -cwd
#$ -o logs/A09b_donor_leiden_fibro_cgn_merge.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A09b_donor_leiden_fibro_cgn_merge
#$ -l h_data=2G,h_rt=1:00:00
#$ -pe shared 2
#$ -t 1-41:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=2
ID=$SGE_TASK_ID
ANNOTS=$PROJDIR/txt/allc_table/donor_leiden_fibro.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/donor_leiden_fibro/${ANNOT}.allc.tsv.gz
OUT=$PROJDIR/allc/donor_leiden_fibro/$ANNOT

time allcools extract-allc \
        --mc_contexts 'CGN' \
        --allc_path $ALLC \
        --output_prefix $OUT \
        --chrom_size_path $CHROM_SIZES \
        --strandness merge \
        --output_format allc \
        --cpu 20

ALLC=$PROJDIR/allc/donor_leiden_fibro/${ANNOT}.CGN-Merge.allc.tsv.gz
tabix -f -b 2 -e 2 -s 1 $ALLC

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
