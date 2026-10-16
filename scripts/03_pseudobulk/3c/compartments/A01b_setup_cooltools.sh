#!/bin/bash
#$ -cwd
#$ -o logs/A01b_setup_cooltools.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_setup_cooltools
#$ -l h_data=2G,h_rt=8:00:00
#$ -pe shared 8
#$ -t 1-51:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

FASTA=/u/project/cluo/terencew/reference/hg38/fasta/hg38.fa

# ID=1
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/pb_designs.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

COOLER=$PROJDIR/merged_contacts/cooler/${ANNOT}.mcool

RES=1000000
OUTDIR=$PROJDIR/compartments/cooltools/
OUT=$OUTDIR/${ANNOT}.out

time cooler dump --header \
    -t bins \
    $COOLER::resolutions/${RES} \
    | cut -f1-3 > $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
