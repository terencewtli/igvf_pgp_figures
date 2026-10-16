#!/bin/bash
#$ -cwd
#$ -o logs/A02a_autosome_bams.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02a_autosome_bams
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

TEMPLATE=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/01_preprocessing/multiome/templates/

SAMPLES=$PROJDIR/txt/samples.txt
ID=${SGE_TASK_ID}
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CR_BASE=$PROJDIR/mapping/cr_arc/igvf_ref/default/

INDIR=$PROJDIR/demux/regular/
cd $INDIR

GEX_BAM=${CR_BASE}/${SAMPLE}/outs/gex_possorted_bam.bam
ATAC_BAM=${CR_BASE}/${SAMPLE}/outs/atac_possorted_bam.bam

GEX_HEADER=$PROJDIR/bam/header/gex/${SAMPLE}.header.autosome.sam
ATAC_HEADER=$PROJDIR/bam/header/atac/${SAMPLE}.header.autosome.sam

GEX_OUT=$INDIR/autosome_bam/gex/${SAMPLE}.bam
ATAC_OUT=$INDIR/autosome_bam/atac/${SAMPLE}.bam

qsub $TEMPLATE/autosome_bam.sh $GEX_BAM $ATAC_BAM $GEX_HEADER $ATAC_HEADER $GEX_OUT $ATAC_OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
