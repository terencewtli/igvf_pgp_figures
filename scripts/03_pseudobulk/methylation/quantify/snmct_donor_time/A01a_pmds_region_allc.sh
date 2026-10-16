#!/bin/bash
#$ -cwd
#$ -o logs/A01a_pmds_region_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_pmds_region_allc
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-34:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.sorted.chromsizes

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

PMDS=$PROJDIR/pmds/dnmtools/donor_time/merged/merged.union.sorted.bed.gz
COMP=$PROJDIR/pmds/dnmtools/donor_time/merged/merged.comp.bed.gz

ALLC=$PROJDIR/allc/donor_time/${ANNOT}.CGN-Merge.allc.tsv.gz

###
OUT=$PROJDIR/bed/donor_time_pmds/donor_time/${ANNOT}

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

###
CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes
PMDS=$PROJDIR/csv/bins/union_pmds_100kb.csv.gz
COMP=$PROJDIR/csv/bins/remove_union_pmds_100kb.csv.gz

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'pmds.bins' \
    --region_bed_paths $PMDS \
    --cpu 1 \
    --save_zero_cov

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'pmds_comp.bins' \
    --region_bed_paths $COMP \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
