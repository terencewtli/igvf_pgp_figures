#!/bin/bash
#$ -cwd
#$ -o logs/A01c_get_sample_bams.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_get_sample_bams
#$ -l h_data=2G,h_rt=8:00:00
#$ -pe shared 8
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}
SAMPLES=$PROJDIR/txt/samples.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CR_BASE=$PROJDIR/mapping/cr_arc/igvf_ref/default

GEX_BAM=$CR_BASE/$SAMPLE/outs/gex_possorted_bam.bam
ATAC_BAM=$CR_BASE/$SAMPLE/outs/atac_possorted_bam.bam
BARCODES=$PROJDIR/txt/barcodes/joint/sample/${SAMPLE}.barcodes.txt

GEX_OUT=$PROJDIR/bam/sample/gex/${SAMPLE}.bam
ATAC_OUT=$PROJDIR/bam/sample/atac/${SAMPLE}.bam

time samtools view -b -h -@ 60 -D CB:$BARCODES $GEX_BAM > $GEX_OUT
samtools index -@ 60 $GEX_OUT

time samtools view -b -h -@ 60 -D CB:$BARCODES $ATAC_BAM > $ATAC_OUT
samtools index -@ 60 $ATAC_OUT

### edit the barcodes
EDIT=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/03_pseudobulk/atac/bam/A01b_pysam_edit_cb.py

time python $EDIT $SAMPLE

GEX_OUT=$PROJDIR/bam/sample/gex/${SAMPLE}.cb.bam
ATAC_OUT=$PROJDIR/bam/sample/atac/${SAMPLE}.cb.bam
samtools index -@ 60 $GEX_OUT
samtools index -@ 60 $ATAC_OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
