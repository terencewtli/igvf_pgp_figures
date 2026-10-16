#!/bin/bash
#$ -cwd
#$ -o logs/A01e_start_fail1_bg.$JOB_ID
#$ -j y
#$ -N A01e_start_fail1_bg
#$ -l h_data=2G,h_rt=4:00:00
#$ -pe shared 2

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

HOMER_PATH=/u/project/cluo/terencew/programs/homer/bin/
export PATH=$PATH:$HOMER_PATH
MOTIFS=$HOMER_PATH/findMotifsGenome.pl

INDIR=$PROJDIR/bed/peaks/chromhmm/start_fail1/

PEAKS=$INDIR/Start.bed
BG=$INDIR/Fail1.bed
OUT=$PROJDIR/motifs/peaks/start_fail1/other_bg/Start
time $MOTIFS $PEAKS hg38 $OUT -bg $BG \
    -size given -p 8

PEAKS=$INDIR/Fail1.bed
BG=$INDIR/Start.bed
OUT=$PROJDIR/motifs/peaks/start_fail1/other_bg/Fail1
time $MOTIFS $PEAKS hg38 $OUT -bg $BG \
    -size given -p 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
