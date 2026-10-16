#!/bin/bash
#$ -cwd
#$ -o logs/A01a_convert_allc_to_methcounts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_convert_allc_to_methcounts
#$ -l h_data=2G,h_rt=4:00:00
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

ALLC=$PROJDIR/allc/donor_time/${ANNOT}.allc.tsv.gz
OUT=$PROJDIR/methcounts/cpg/donor_time/${ANNOT}.methcounts.tsv.gz

### extract CGN and rename to CpG

time zcat $ALLC | cut -f1-6 - \
    | awk '$4 ~ /^CG/ { print $0 }' | \
    awk -v OFS='\t' \
    '{ $4 = "CpG" } {$5 /= $6 } { print $0 }' \
    | gzip - > $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
