#!/bin/bash
#$ -cwd
#$ -o logs/A01b_reheader_to_auto.$JOB_ID
#$ -j y
#$ -N A01b_reheader_to_auto
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 4

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

VCF=$PROJDIR/vcf/wgs/pgp_filt1.rm_missing.vcf.gz
HEADER=$PROJDIR/vcf/wgs/txt/header.txt
AUTO_HEADER=$PROJDIR/vcf/wgs/txt/header.autosome.txt

bcftools view -H $VCF > $HEADER

### manually edit autosome header

OUT=$PROJDIR/vcf/wgs/pgp_filt1.rm_missing.reheader.vcf.gz

time bcftools reheader -h $AUTO_HEADER -o $OUT $VCF
