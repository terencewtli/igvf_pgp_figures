#!/bin/bash
#$ -cwd
#$ -o logs/A01c_prepare_impute.$JOB_ID
#$ -j y
#$ -N A01c_prepare_impute
#$ -l h_data=4G,h_rt=4:00:00
#$ -pe shared 4

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

CONTACTS=$PROJDIR/csv/to_impute/merged.csv

### 100kb
COMMON_PARAMS="--cell_table $CONTACTS \
               --batch_size 100 \
               --pad 1 \
               --cpu_per_job 50 \
               --chr1 0 \
               --pos1 1 \
               --chr2 2 \
               --pos2 3 \
               --chrom_size_path $CHROM_SIZES \
               --output_dist 500000000 \
               --window_size 500000000 \
               --step_size 500000000"

OUTDIR=$PROJDIR/snkmk_imputed/1M/
OUT="--output_dir $OUTDIR"
RES="--resolution 1000000"
time hicluster prepare-impute $COMMON_PARAMS $RES $OUT

OUTDIR=$PROJDIR/snkmk_imputed/500K/
OUT="--output_dir $OUTDIR"
RES="--resolution 500000"
time hicluster prepare-impute $COMMON_PARAMS $RES $OUT

OUTDIR=$PROJDIR/snkmk_imputed/100K/
OUT="--output_dir $OUTDIR"
RES="--resolution 100000"
time hicluster prepare-impute $COMMON_PARAMS $RES $OUT

OUTDIR=$PROJDIR/snkmk_imputed/25K/
OUT="--output_dir $OUTDIR"
RES="--resolution 25000"
time hicluster prepare-impute $COMMON_PARAMS $RES $OUT

OUTDIR=$PROJDIR/snkmk_imputed/10K/
OUT="--output_dir $OUTDIR"
RES="--resolution 10000"
time hicluster prepare-impute $COMMON_PARAMS $RES $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
