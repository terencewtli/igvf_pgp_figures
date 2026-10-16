#!/bin/bash
#$ -cwd
#$ -o logs/A01b_setup_crarc_libraries.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_setup_crarc_libraries
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

FASTQ_DIR=/u/project/cluo/Shared_Datasets/IGVF/202208_Pilot/new_multiome/YS3_Testrun3/Fastqs

HEADER='fastqs,sample,library_type'

# ID=1

for ID in `seq 1 10`;
do
  LIB=$PROJDIR/csv/cr_arc/multi${ID}.csv

  GEX_SAMPLES=$PROJDIR/txt/gex_samples.txt
  GEX_SAMPLE=$(head -${ID} $GEX_SAMPLES | tail -1)

  ATAC_SAMPLES=$PROJDIR/txt/atac_samples.txt
  ATAC_SAMPLE=$(head -${ID} $ATAC_SAMPLES | tail -1)

  GEX_FASTQ=${FASTQ_DIR}/2023.09.12_YS3_GEX
  ATAC_FASTQ=$PROJDIR/fastq/atac/
  GEX="$GEX_FASTQ,$GEX_SAMPLE,Gene Expression"
  ATAC="$ATAC_FASTQ,${ATAC_SAMPLE}_ATAC,Chromatin Accessibility"

  echo -e "$HEADER\n$ATAC\n$GEX" > $LIB
done

echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date `
echo " "
