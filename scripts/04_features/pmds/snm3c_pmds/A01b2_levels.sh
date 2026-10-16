#!/bin/bash
#$ -cwd
#$ -o logs/A01b2_levels.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b2_levels
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

### assumes I have run notebook
### ipynb/setup_pseudo/01a_*

source ~/.bashrc

conda activate dnmtools_env

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

METH=$PROJDIR/methcounts/sym_cpg/donor_time/${ANNOT}.methcounts.tsv.gz
OUT=$PROJDIR/methcounts/levels/donor_time/${ANNOT}.levels

time dnmtools levels -relaxed -v -o $OUT $METH

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
