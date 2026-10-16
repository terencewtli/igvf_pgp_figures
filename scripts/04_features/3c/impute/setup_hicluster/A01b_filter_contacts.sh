#!/bin/bash
#$ -cwd
#$ -o logs/A01b_filter_contacts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_filter_contacts
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-285:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate schicluster

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=$SGE_TASK_ID
printf -v BATCH "%03d" $(($ID - 1))

CONTACTS=$PROJDIR/csv/contacts/batch/${BATCH}.csv

BL_ONE=/u/project/cluo/terencew/reference/blacklist/hg38_ENCODE_blacklist.autosomal.bed
BL_TWO=/u/project/cluo/terencew/reference/blacklist/hg38_2d_blacklist.bedpe.gz

OUTDIR=$PROJDIR/rmbkl/

FILTER="hicluster filter-contact \
        --output_dir $OUTDIR \
        --blacklist_1d_path $BL_ONE \
        --blacklist_2d_path $BL_TWO \
        --cpu 10 \
        --chr1 0 \
        --pos1 1 \
        --chr2 2 \
        --pos2 3 \
        --contact_table $CONTACTS \
        --chrom_size_path $CHROM_SIZES"

time $FILTER

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
