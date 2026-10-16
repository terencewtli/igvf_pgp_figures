#!/bin/bash
#$ -cwd
#$ -o logs/A01a_get_pmd_mcg.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_get_pmd_mcg
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-261:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/mc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))

ALLC_PATHS=$PROJDIR/txt/batch/allc/${BATCH}.txt

for ALLC in $(cat $ALLC_PATHS);
do

  NUCLEUS=$(basename ${ALLC%.allc.tsv.gz})

  ALLC=$PROJDIR/allc/raw/${NUCLEUS}.CGN-Merge.allc.tsv.gz
  OUT=$PROJDIR/bed/pmds/${NUCLEUS}

  ###
  INDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
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
done

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
