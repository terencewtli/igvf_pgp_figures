#!/bin/bash
#$ -cwd
#$ -o logs/A01f_sumcell_time.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01f_sumcell_time
#$ -l h_data=1G,h_rt=2:00:00
#$ -pe shared 4
#$ -t 1-220:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate hiclusterv2

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}
SAMPLES=$PROJDIR/txt/loops/annots/time.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CELL_LIST=$PROJDIR/txt/loops/time/${SAMPLE}.txt

TMP_SAMPLE=${SAMPLE%_chr*}

OUT=$PROJDIR/old_hicluster/imputed_matrix/10kb_resolution/merged/time/$TMP_SAMPLE/$SAMPLE
RES=10000

time hicluster loop-sumcell-chr \
  --cell_list $CELL_LIST \
  --outprefix $OUT \
  --res $RES

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
