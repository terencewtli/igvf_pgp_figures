#!/bin/bash
#$ -cwd
#$ -o logs/A02g_fail_traj_dmrs.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02g_fail_traj_dmrs
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-10:1

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
ANNOTS=$PROJDIR/txt/allc_table/rna_cluster.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/rna_cluster/${ANNOT}.CGN-Merge.allc.tsv.gz
OUT=$PROJDIR/bed/features/rna_cluster/${ANNOT}

START_DELAYED_DMRS=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/csv/dmrs/rna_cluster/fail_traj/start_delayed.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'start_delayed_dmrs' \
    --region_bed_paths $START_DELAYED_DMRS \
    --cpu 1 \
    --save_zero_cov

DELAYED_FAIL1_DMRS=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/csv/dmrs/rna_cluster/fail_traj/delayed_fail1.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'delayed_fail1_dmrs' \
    --region_bed_paths $DELAYED_FAIL1_DMRS \
    --cpu 1 \
    --save_zero_cov

START_FAIL1_DMRS=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/csv/dmrs/rna_cluster/fail_traj/start_fail1.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'start_fail1_dmrs' \
    --region_bed_paths $START_FAIL1_DMRS \
    --cpu 1 \

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
