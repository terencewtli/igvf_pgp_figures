#!/bin/bash
#$ -cwd
#$ -o logs/A02b_get_pmd_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02b_get_pmd_allc
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-6:1

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

ANNOTS=$PROJDIR/txt/allc_table/liftover_sub.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/liftover_sub/${ANNOT}.CGN-Merge.allc.tsv.gz
OUT=$PROJDIR/bed/pmds/liftover_sub/${ANNOT}

INDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
###
RAW_PMDS=$INDIR/pmds/dnmtools/rna_cluster_donor/merged/tmp/start_merged.sorted.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'raw_pmds' \
    --region_bed_paths $RAW_PMDS \
    --cpu 1 \
    --save_zero_cov

###
START_PMDS=$INDIR/pmds/dnmtools/rna_cluster_donor/merged/start_merged.filt_mcg.sorted.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'start_pmds' \
    --region_bed_paths $START_PMDS \
    --cpu 1 \
    --save_zero_cov

###
START_PMDS_COMP=$INDIR/pmds/dnmtools/rna_cluster_donor/merged/start_merged.filt_mcg.comp.sorted.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'start_pmds_comp' \
    --region_bed_paths $START_PMDS_COMP \
    --cpu 1 \
    --save_zero_cov

### what about their own pmds?

PMDS=$INDIR/pmds/dnmtools/rna_cluster_donor/$ANNOT/${ANNOT}.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'pmds' \
    --region_bed_paths $PMDS \
    --cpu 1 \
    --save_zero_cov

### PMD windows
PMDS_WINDOWS=$INDIR/csv/pmds/rna_cluster_donor/start.filt_mcg.windows.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'pmds_windows' \
    --region_bed_paths $PMDS_WINDOWS \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
