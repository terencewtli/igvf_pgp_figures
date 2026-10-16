#!/bin/bash
#$ -cwd
#$ -o logs/A01d_tabix_contacts.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_tabix_contacts
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 1
#$ -t 1-36:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scFates

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/donor_time.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

SCRATCH=/u/project/cluo_scratch/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
INDIR=$SCRATCH/merged_contacts/raw/donor_time/
CONTACTS=$INDIR/${SAMPLE}.tsv.gz

OUTDIR=$SCRATCH/merged_contacts/raw/donor_time/submit
OUT=$OUTDIR/${SAMPLE}.tsv
OUT_SORTED=$OUTDIR/${SAMPLE}.sorted.tsv
zcat $CONTACTS > $OUT
sort -k1,1 -k2,2n $OUT > $OUT_SORTED
bgzip $OUT_SORTED
tabix -s 1 -b 2 -e 2 ${OUT_SORTED}.gz

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
