#!/bin/bash
#$ -cwd
#$ -o logs/A01a_pmds_roi_meth.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_pmds_roi_meth
#$ -l h_data=2G,h_rt=1:00:00
#$ -pe shared 4
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate dnmtools_env

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc
cd $PROJDIR

# ID=2
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)
echo $ANNOT

METH=$PROJDIR/methcounts/sym_cpg_autosome/donor_time/${ANNOT}.methcounts.tsv.gz
TMP=$PROJDIR/tmp/methcounts/${ANNOT}.methcounts.tsv

zcat $METH > $TMP

PMDS=$PROJDIR/pmds/dnmtools/donor_time/${ANNOT}/${ANNOT}.bed

OUT=$PROJDIR/bed/pmd_meth/donor_time/${ANNOT}.bed
SEED=1

time dnmtools roi -v -s -o $OUT -M $PMDS $TMP

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
