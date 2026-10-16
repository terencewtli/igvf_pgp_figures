#!/bin/bash
#$ -cwd
#$ -o logs/A01a_donor_coarse_bigwig.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_donor_coarse_bigwig
#$ -l h_data=4G,h_rt=4:00:00
#$ -pe shared 8
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

### assumes I have run notebook
### ipynb/setup_pseudo/01a_*

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38/hg38.chrom.sizes

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/donor_time/${ANNOT}.allc.tsv.gz
OUT=$PROJDIR/bigwig/donor_time/${ANNOT}.bigwig

time allcools allc-to-bigwig --allc_path $ALLC \
    --output_prefix $OUT \
    --mc_contexts 'CGN' \
    --chrom_size_path $CHROM_SIZES

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
