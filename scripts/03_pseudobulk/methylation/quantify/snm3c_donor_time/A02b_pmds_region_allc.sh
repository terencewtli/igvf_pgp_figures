#!/bin/bash
#$ -cwd
#$ -o logs/A02b_pmds_region_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02b_pmds_region_allc
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 4
#$ -t 1-36:1

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

ANNOTS=$PROJDIR/txt/allc_table/liftover.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

###
INDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
PMDS=$INDIR/pmds/dnmtools/liftover/merged/fibro_merged.bed.gz
COMP=$INDIR/pmds/dnmtools/liftover/merged/fibro_merged.comp.bed.gz

ALLC=$PROJDIR/allc/liftover/${ANNOT}.CGN-Merge.allc.tsv.gz

###
OUT=$PROJDIR/bed/start_pmds/liftover/${ANNOT}

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'pmds' \
    --region_bed_paths $PMDS \
    --cpu 1 \
    --save_zero_cov

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'pmds_comp' \
    --region_bed_paths $COMP \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
