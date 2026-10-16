#!/bin/bash
#$ -cwd
#$ -o logs/A02e_union_peaks.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02e_union_peaks
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-8:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/allc_table/ips_cluster_donor.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/ips_cluster_donor/${ANNOT}.CGN-Merge.allc.tsv.gz

OUT=$PROJDIR/bed/features/ips_cluster_donor/${ANNOT}

INDIR=/u/project/cluo/terencew/igvf/50_line/multiome
PEAKS=$INDIR/bed/peaks/merge_pgp/pgp_union.autosome.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'mature_union_peaks' \
    --region_bed_paths $PEAKS \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
