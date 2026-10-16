#!/bin/bash
#$ -cwd
#$ -o logs/A01d_pmds_genomecov.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_pmds_genomecov
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 1
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate dnmtools_env

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

METH=$PROJDIR/methcounts/sym_cpg_autosome/donor_time/${ANNOT}.methcounts.tsv.gz
INDIR=$PROJDIR/pmds/dnmtools/donor_time/${ANNOT}
PMDS=$INDIR/${ANNOT}.bed
OUT=$INDIR/${ANNOT}.genomecov

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.chromsizes

time bedtools genomecov -i $PMDS -g $CHROM_SIZES > $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
