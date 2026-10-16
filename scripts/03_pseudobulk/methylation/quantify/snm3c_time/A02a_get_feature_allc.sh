#!/bin/bash
#$ -cwd
#$ -o logs/A02a_get_feature_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02a_get_feature_allc
#$ -l h_data=2G,h_rt=1:00:00
#$ -pe shared 2
#$ -t 1-8:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/time/${ANNOT}.CGN-Merge.allc.tsv.gz
OUT=$PROJDIR/bed/bins/time/${ANNOT}

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --bin_sizes 100000 5000 500 \
    --cpu 1 \
    --save_zero_cov

OUT=$PROJDIR/bed/features/time/${ANNOT}
GENES=/u/project/cluo/terencew/reference/hg38_igvf/bed/gencode.v43.genes.autosome.slop2k.bed.gz

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'genes' \
    --region_bed_paths $GENES \
    --cpu 1 \
    --save_zero_cov

PEAKS=/u/project/cluo/terencew/igvf/2023_YR2/multiome/bed/peaks/intersect_rna.peaks.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'peaks' \
    --region_bed_paths $PEAKS \
    --cpu 1 \
    --save_zero_cov

DMRS=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/csv/dmrs/rna_cluster/dmrs.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'dmrs' \
    --region_bed_paths $DMRS \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
