#!/bin/bash
#$ -cwd
#$ -o logs/A01d_start_fail1.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_start_fail1
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2
#$ -t 1-2:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

LIST=(Start Fail1)
# ID=1
ID=${SGE_TASK_ID}
ANNOT=${LIST[$((ID-1))]}

HOMER_PATH=/u/project/cluo/terencew/programs/homer/bin/
export PATH=$PATH:$HOMER_PATH
MOTIFS=$HOMER_PATH/findMotifsGenome.pl

INDIR=$PROJDIR/bed/peaks/chromhmm/start_fail1/
PEAKS=$INDIR/${ANNOT}.bed

OUT=$PROJDIR/motifs/peaks/start_fail1/${ANNOT}
time $MOTIFS $PEAKS hg38 $OUT -size given -p 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
