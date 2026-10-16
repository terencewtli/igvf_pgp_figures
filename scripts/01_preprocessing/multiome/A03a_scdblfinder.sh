#!/bin/bash
#$ -cwd
#$ -o logs/A03a_scdblfinder.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A03a_scdblfinder
#$ -l h_data=6G,h_rt=8:00:00,h_vmem=64G
#$ -pe shared 8
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

SAMPLES=$PROJDIR/txt/samples.txt

# ID=1
ID=${SGE_TASK_ID}
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

COUNTS=$PROJDIR/rna/ambimux/wgs/${SAMPLE}/

OUTDIR=$PROJDIR/doublets/dblfinder/gex/ambimux/wgs/$SAMPLE/
DEMUXAFY=/u/project/cluo/terencew/programs/Demuxafy.sif
CMD=scDblFinder.R

time singularity exec $DEMUXAFY $CMD \
  -o $OUTDIR -t $COUNTS

echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date `
echo " "
