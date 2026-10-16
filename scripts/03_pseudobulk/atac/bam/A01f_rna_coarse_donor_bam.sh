#!/bin/bash
#$ -cwd
#$ -o logs/A01f_rna_coarse_donor_bam.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01f_rna_coarse_donor_bam
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-40:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

TMP=/u/project/cluo_scratch/terencew/tmp/bam/

SAMPLES=$PROJDIR/txt/tmp/samples.txt

# ID=1
ID=${SGE_TASK_ID}
CLUSTERS=$PROJDIR/txt/bam_table/rna_coarse_donor.txt
CLUSTER=$(head -${ID} $CLUSTERS | tail -1)

echo 'generating per-sample bams'
time for SAMPLE in $(cat $SAMPLES);
do
  BARCODES=$PROJDIR/txt/barcodes/joint/rna_coarse_donor/${SAMPLE}/${CLUSTER}.txt
  GEX_BAM=$PROJDIR/bam/sample/gex/${SAMPLE}.cb.bam
  ATAC_BAM=$PROJDIR/bam/sample/atac/${SAMPLE}.cb.bam

  GEX_OUT=$TMP/rna_coarse_donor/${CLUSTER}.${SAMPLE}.gex.bam
  ATAC_OUT=$TMP/rna_coarse_donor/${CLUSTER}.${SAMPLE}.atac.bam

  samtools view -@ 40 -h -b -D CB:$BARCODES $GEX_BAM > $GEX_OUT
  samtools view -@ 40 -h -b -D CB:$BARCODES $ATAC_BAM > $ATAC_OUT

  samtools index -@ 40 $GEX_OUT
  samtools index -@ 40 $ATAC_OUT
done

###

echo 'merging sample bams'
GEX_LIST=$TMP/rna_coarse_donor/${CLUSTER}.gex.txt
ATAC_LIST=$TMP/rna_coarse_donor/${CLUSTER}.atac.txt

ls $TMP/rna_coarse_donor/${CLUSTER}.*.gex.bam > $GEX_LIST
ls $TMP/rna_coarse_donor/${CLUSTER}.*.atac.bam > $ATAC_LIST

GEX_FINAL=$PROJDIR/bam/rna_coarse_donor/gex/${CLUSTER}.bam
ATAC_FINAL=$PROJDIR/bam/rna_coarse_donor/atac/${CLUSTER}.bam
samtools merge -@ 40 -f -o $GEX_FINAL -b $GEX_LIST
samtools merge -@ 40 -f -o $ATAC_FINAL -b $ATAC_LIST

samtools index -@ 40 $GEX_FINAL
samtools index -@ 40 $ATAC_FINAL

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
