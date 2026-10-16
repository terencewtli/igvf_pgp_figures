#!/bin/bash
#$ -cwd
#$ -o logs/A01a_setup_cistarget_on_peaks.$JOB_ID
#$ -j y
#$ -N A01a_setup_cistarget_on_peaks
#$ -l h_data=2G,h_rt=8:00:00
#$ -pe shared 4

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scenicplus

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

# module load cluster/wice/bigmem

REGION_BED=$PROJDIR/atac/peaks/archr/clusters/clusters_v6.bed
GENOME_FASTA=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.fa
CHROMSIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.chromsizes
DATABASE_PREFIX='stem_cell'

SCRIPT_DIR=/u/project/cluo/terencew/programs/create_cisTarget_databases/
CREATE_FASTA=${SCRIPT_DIR}/create_fasta_with_padded_bg_from_bed.sh

OUT=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.1kb_bg_padding.fa

time $CREATE_FASTA \
        ${GENOME_FASTA} \
        ${CHROMSIZES} \
        ${REGION_BED} \
        $OUT \
        1000 \
        yes

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
