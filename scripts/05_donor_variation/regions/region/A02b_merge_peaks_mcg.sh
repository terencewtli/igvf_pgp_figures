#!/bin/bash
#$ -cwd
#$ -o logs/A02b_merge_peaks_mcg.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02b_merge_peaks_mcg
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-196:1

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

ALLC_PATHS=$PROJDIR/txt/batch/peaks/${BATCH}.txt
OUTDIR=$PROJDIR/csv/peaks/batch

MERGE=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/05_donor_variation/regions/region/A02a_merge_peaks_mcg.py

time python $MERGE $ALLC_PATHS $OUTDIR $BATCH

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
