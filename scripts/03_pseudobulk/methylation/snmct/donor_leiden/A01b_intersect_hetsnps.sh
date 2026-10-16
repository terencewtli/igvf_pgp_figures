#!/bin/bash
#$ -cwd
#$ -o logs/A01b_intersect_hetsnps.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01b_intersect_hetsnps
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-49:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
ANNOTS=$PROJDIR/txt/allc_table/donor_leiden.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

DONOR=${ANNOT%_D*}
VCF=/u/project/cluo/terencew/igvf/2023_YR2/genotypes/vcf/imputed/by_donor/het_snps/${DONOR}.vcf.gz

###
BAM=$PROJDIR/bam/donor_leiden/${ANNOT}.bam
OUT=$PROJDIR/bam/het_snps/donor_leiden/intersect/${ANNOT}.bam
time bedtools intersect -a $BAM -b $VCF -wa -u > $OUT
samtools index $OUT

###
BAM=$PROJDIR/bam/donor_leiden/${ANNOT}.forward.bam
OUT=$PROJDIR/bam/het_snps/donor_leiden/intersect/${ANNOT}.forward.bam
time bedtools intersect -a $BAM -b $VCF -wa -u > $OUT
samtools index $OUT

###
BAM=$PROJDIR/bam/donor_leiden/${ANNOT}.reverse.bam
OUT=$PROJDIR/bam/het_snps/donor_leiden/intersect/${ANNOT}.reverse.bam
time bedtools intersect -a $BAM -b $VCF -wa -u > $OUT
samtools index $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
