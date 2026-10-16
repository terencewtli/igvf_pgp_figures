#!/bin/bash
#$ -cwd
#$ -o logs/A01d_pmd_merge.$JOB_ID
#$ -j y
#$ -N A01d_pmd_merge
#$ -l h_data=2G,h_rt=1:00:00
#$ -pe shared 2

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.sorted.chromsizes

INDIR=$PROJDIR/pmds/dnmtools/rna_cluster_donor/
cd $INDIR

ALL=$INDIR/merged/all_pmds.bed
cat $INDIR/*_*/*.bed | sort -k1,1 -k2,2n > $ALL

MERGED=$INDIR/merged/merged.bed
bedtools merge -i $ALL > $MERGED

COMP=$INDIR/merged/merged.comp.bed
bedtools complement -i $MERGED -g $CHROM_SIZES > $COMP

### I think maybe just doing fibroblast PMDs makes more sense?

ALL=$INDIR/merged/start_all_pmds.bed
cat $INDIR/Start_*/*.bed | sort -k1,1 -k2,2n > $ALL

MERGED=$INDIR/merged/start_merged.bed
bedtools merge -i $ALL > $MERGED

COMP=$INDIR/merged/start_merged.comp.bed
bedtools complement -i $MERGED -g $CHROM_SIZES > $COMP

###
CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.chromsizes
MERGED=$INDIR/merged/start_merged.bed
OUT=$INDIR/merged/start_merged.gcov
time bedtools genomecov -i $MERGED -g $CHROM_SIZES > $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
