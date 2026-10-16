#!/bin/bash
#$ -cwd
#$ -o logs/A01b_cgn_merge.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_cgn_merge
#$ -l h_data=2G,h_rt=8:00:00
#$ -pe shared 2
#$ -t 1-393:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/mc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))

ALLC_PATHS=$PROJDIR/txt/batch/allc/${BATCH}.txt

OUTDIR=$PROJDIR/allc/raw/

time for ALLC in $(cat $ALLC_PATHS);
do
  NUCLEUS=$(basename ${ALLC%.allc.tsv.gz})
  OUT=${OUTDIR}/${NUCLEUS}.allc.tsv
  zcat $ALLC > $OUT
  bgzip -f $OUT
  tabix -f -b 2 -e 2 ${OUT}.gz

  TMP_ALLC=${OUTDIR}/${NUCLEUS}.allc.tsv.gz
  OUT=${OUTDIR}/${NUCLEUS}

  allcools extract-allc \
          --mc_contexts 'CGN' \
          --allc_path $TMP_ALLC \
          --output_prefix $OUT \
          --chrom_size_path $CHROM_SIZES \
          --strandness merge \
          --output_format allc \
          --cpu 20

  OUT=${OUTDIR}/${NUCLEUS}.CGN-Merge.allc.tsv.gz
  tabix -f -b 2 -e 2 $OUT
  rm -f ${OUTDIR}/${NUCLEUS}*Tmp*
done

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
