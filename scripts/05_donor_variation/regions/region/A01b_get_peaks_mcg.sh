#!/bin/bash
#$ -cwd
#$ -o logs/A01b_get_peaks_mcg.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_get_peaks_mcg
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
  OUT=$PROJDIR/bed/peaks/${NUCLEUS}

  CHROMHMM_PEAKS=/u/project/cluo/terencew/igvf/2023_YR2/multiome/atac/peaks/chromhmm/justin.chromhmm.bed.gz
  time allcools region --allc_path $ALLC \
      --output_prefix $OUT \
      --chrom_size_path $CHROM_SIZES \
      --mc_contexts 'CGN' \
      --region_bed_names 'chromhmm_peaks' \
      --region_bed_paths $CHROMHMM_PEAKS \
      --cpu 1 \
      --save_zero_cov
done

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
