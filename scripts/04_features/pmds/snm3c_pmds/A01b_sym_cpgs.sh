#!/bin/bash
#$ -cwd
#$ -o logs/A01b_sym_cpgs.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_sym_cpgs
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

### assumes I have run notebook
### ipynb/setup_pseudo/01a_*

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_allc/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

METH=$PROJDIR/methcounts/cpg/donor_time/${ANNOT}.methcounts.tsv.gz
SYM=$PROJDIR/methcounts/sym_cpg/donor_time/${ANNOT}.methcounts.tsv.gz

DNMTOOLS=/u/project/cluo/terencew/programs/dnmtools-1.0.0/dnmtools

time $DNMTOOLS sym -v -o $SYM $METH

AUTO_SYM=$PROJDIR/methcounts/sym_cpg_autosome/donor_time/${ANNOT}.methcounts.tsv.gz

time zcat $SYM | grep -v -e 'chrX' -e 'chrY' -e 'chrM' | gzip - > $AUTO_SYM

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
