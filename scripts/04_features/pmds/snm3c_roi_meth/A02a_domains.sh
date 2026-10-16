#!/bin/bash
#$ -cwd
#$ -o logs/A02a_domains.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02a_domains
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

ID=1

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)
echo $ANNOT

METH=$PROJDIR/methcounts/sym_cpg_autosome/donor_time/${ANNOT}.methcounts.tsv.gz
TMP=$PROJDIR/tmp/methcounts/${ANNOT}.methcounts.tsv

zcat $METH > $TMP

### C29 day 3 for now lol
### switch to use awk to filter 4th column
BOUNDARIES=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/tmp/C29_D3.boundary.bed
OUT=$PROJDIR/bed/tad_meth/donor_time/${ANNOT}.boundary.bed

time dnmtools roi -v -s -o $OUT -M $BOUNDARIES $TMP

DOMAINS=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/tmp/C29_D3.domain.bed
OUT=$PROJDIR/bed/tad_meth/donor_time/${ANNOT}.domain.bed

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
