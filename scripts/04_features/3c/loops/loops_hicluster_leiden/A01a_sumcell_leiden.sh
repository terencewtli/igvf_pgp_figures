#!/bin/bash
#$ -cwd
#$ -o logs/A01a_sumcell_leiden.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01a_sumcell_leiden
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 4
#$ -t 1-792:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate hiclusterv2

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

### switch to same pseudobulk allc syntax
# ID=1
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/loops/annots/donor_time.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

CELL_LIST=$PROJDIR/txt/loops/donor_time/tmp/${ANNOT}.txt

TMP_ANNOT=${ANNOT%_chr*}

OUT=$PROJDIR/old_hicluster/imputed_matrix/10kb_resolution/merged/donor_time/$TMP_ANNOT/$ANNOT
RES=10000

time hicluster loop-sumcell-chr \
  --cell_list $CELL_LIST \
  --outprefix $OUT \
  --res $RES

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
