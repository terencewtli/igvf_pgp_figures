#!/bin/bash
#$ -cwd
#$ -o logs/A01b_bins_region_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_bins_region_allc
#$ -l h_data=2G,h_rt=1:00:00
#$ -pe shared 2
#$ -t 1-34:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38/hg38.chrom.sizes

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/donor_time/${ANNOT}.CGN-Merge.allc.tsv.gz

###
OUT=$PROJDIR/bed/bins/donor_time/${ANNOT}

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --bin_sizes 100000,5000 \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
