#!/bin/bash
#$ -cwd
#$ -o logs/A02f_variance_comparison.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02f_variance_comparison
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-40:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/allc_table/rna_cluster_donor.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

### CpG Islands
OUT=$PROJDIR/bed/features/rna_cluster_donor/${ANNOT}
CPG_ISLANDS=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/mc/bed/mcds/cpg_islands.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'cpg_islands' \
    --region_bed_paths $CPG_ISLANDS \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
