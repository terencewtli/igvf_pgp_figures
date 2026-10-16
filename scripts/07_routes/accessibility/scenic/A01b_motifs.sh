#!/bin/bash
#$ -cwd
#$ -o logs/A01b_motifs.$JOB_ID
#$ -j y
#$ -N A01b_motifs
#$ -l h_data=2G,h_rt=24:00:00,highp
#$ -pe shared 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scenicplus

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

DATABASE_PREFIX='stem_cell'

FASTA_FILE=$PROJDIR/reference/scenic/GRCh38.1kb_bg_padding.fa
CBDIR=/u/project/cluo/terencew/reference/aertslab_motif_collection/v10nr_clust_public/singletons

MOTIF_LIST=$PROJDIR/reference/scenic/motifs.txt
OUT=$PROJDIR/reference/scenic/$DATABASE_PREFIX

SCRIPT_DIR=/u/project/cluo/terencew/programs/create_cisTarget_databases/
MOTIFS=${SCRIPT_DIR}/create_cistarget_motif_databases.py

time $MOTIFS \
    -f ${FASTA_FILE} \
    -M ${CBDIR} \
    -m ${MOTIF_LIST} \
    -o $OUT \
    --bgpadding 1000 \
    -t 40

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
