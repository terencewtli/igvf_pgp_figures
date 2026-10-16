#!/bin/bash
#$ -cwd
#$ -o logs/A01c_coarse_peaks.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_coarse_peaks
#$ -l h_data=2G,h_rt=8:00:00
#$ -pe shared 2
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/clusters/coarse.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

HOMER_PATH=/u/project/cluo/terencew/programs/homer/bin/
export PATH=$PATH:$HOMER_PATH
MOTIFS=$HOMER_PATH/findMotifsGenome.pl

INDIR=$PROJDIR/atac/peaks/chromhmm/coarse/
PEAKS=$INDIR/${ANNOT}.bed

OUT=$PROJDIR/motifs/peaks/coarse/${ANNOT}
time $MOTIFS $PEAKS hg38 $OUT -size given -p 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
