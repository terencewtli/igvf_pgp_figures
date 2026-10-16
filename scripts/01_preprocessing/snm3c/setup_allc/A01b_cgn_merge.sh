#!/bin/bash
#$ -cwd
#$ -o logs/A01b_cgn_merge.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_cgn_merge
#$ -l h_data=1G,h_rt=3:00:00
#$ -pe shared 1
#$ -t 1-285:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/mc
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))

ALLC_PATHS=$PROJDIR/txt/batch/allc/${BATCH}.txt

OUTDIR=$PROJDIR/allc/raw/

time for ALLC in $(cat $ALLC_PATHS);
do
  NUCLEUS=$(basename ${ALLC%.allc.gz})
  OUT=${OUTDIR}/${NUCLEUS}.allc.gz
  cp -f $ALLC $OUT
  tabix -f -b 2 -e 2 $OUT

  TMP_ALLC=${OUTDIR}/${NUCLEUS}.allc.gz
  OUT=${OUTDIR}/${NUCLEUS}

  allcools extract-allc \
          --mc_contexts 'CGN' \
          --allc_path $TMP_ALLC \
          --output_prefix $OUT \
          --chrom_size_path $CHROM_SIZES \
          --strandness merge \
          --output_format allc \
          --cpu 20
  CGN_OUT=${OUTDIR}/${NUCLEUS}.CGN-Merge.allc.tsv.gz
  tabix -f -b 2 -e 2 $CGN_OUT
done

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
