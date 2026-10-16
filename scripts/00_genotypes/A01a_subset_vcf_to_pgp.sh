#!/bin/bash
#$ -cwd
#$ -o logs/A01a_subset_vcf_to_pgp.$JOB_ID
#$ -j y
#$ -N A01a_subset_vcf_to_pgp
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

INDIR=/u/project/cluo/IGVF_Share/genotypes/WGS01/vcf_joint/
VCF=$INDIR/snpindel_filt1.bcf
OUT=$PROJDIR/vcf/wgs/pgp_filt1.vcf.gz

SAMPLES=$PROJDIR/txt/donors.txt

time bcftools view -v snps \
    -S $SAMPLES \
    -Oz -o $OUT $VCF --threads 40

### remove missing samples

VCF=$PROJDIR/vcf/wgs/pgp_filt1.vcf.gz
OUT=$PROJDIR/vcf/wgs/pgp_filt1.rm_missing.vcf.gz

time bcftools view -g ^miss \
    -Oz -o $OUT $VCF --threads 40

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
