#!/bin/bash
#$ -cwd
#$ -o logs/A01c_gene_score.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_gene_score
#$ -l h_data=4G,h_rt=4:00:00
#$ -pe shared 4
#$ -t 1-208:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

GENES=/u/project/cluo/terencew/reference/hg38_igvf/annotations/genebody.bed
CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))
CELL_TABLE=$PROJDIR/csv/imputed/10K/batch/${BATCH}.csv
OUT=$PROJDIR/gene_score/batch/${BATCH}.hdf5

time hicluster gene-score \
    --cpu 50 \
    --mode impute \
    --cell_table_path $CELL_TABLE \
    --gene_meta_path $GENES \
    --resolution 10000 \
    --output_hdf_path $OUT \
    --chr1 0 --pos1 1 --chr2 2 --pos2 3 \
    --chrom_size_path $CHROM_SIZES

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
