#!/bin/bash
#$ -cwd
#$ -o logs/A01d_mask_wgs_rna_cluster_donor.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_mask_wgs_rna_cluster_donor
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-40:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}

ANNOTS=$PROJDIR/txt/allc_table/rna_cluster_donor.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

DONOR=${ANNOT#*_}
SNPS=/u/project/cluo/terencew/igvf/2023_YR2/genotypes/vcf/wgs/by_donor/all_snps/${DONOR}.vcf.gz

ALLC=$PROJDIR/allc/rna_cluster_donor/${ANNOT}.CGN-Merge.allc.tsv.gz
ALLC_BED=$PROJDIR/tmp/bed/${ANNOT}.allc.bed

zcat $ALLC | \
    awk -v OFS='\t' '{print $1,$2,$2+1,$3,$4,$5,$6,$7}' \
    > $ALLC_BED

MASKED=$PROJDIR/tmp/bed/${ANNOT}.masked.allc.bed
OUT=$PROJDIR/allc/snp_masked/rna_cluster_donor/${ANNOT}.CGN-Merge.allc.tsv

time bedtools subtract -a $ALLC_BED -b $SNPS > $MASKED

awk -v OFS='\t' '{print $1,$2,$4,$5,$6,$7,$8}' $MASKED > $OUT
bgzip -f $OUT
tabix -f -b 2 -e 2 -s 1 ${OUT}.gz

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
