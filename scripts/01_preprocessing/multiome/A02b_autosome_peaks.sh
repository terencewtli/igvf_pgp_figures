#!/bin/bash
#$ -cwd
#$ -o logs/A02b_autosome_peaks.$JOB_ID
#$ -j y
#$ -N A02b_autosome_peaks
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

TEMPLATE=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/01_preprocessing/multiome/templates/
CR_BASE=$PROJDIR/mapping/cr_arc/igvf_ref/default/

SAMPLES=$PROJDIR/txt/samples.txt

time for ID in `seq 1 10`;
do
  SAMPLE=$(head -${ID} $SAMPLES | tail -1)
  INDIR=$CR_BASE/$SAMPLE/outs/
  OUTDIR=$PROJDIR/atac/peaks/cr_arc/
  python $TEMPLATE/autosome_peaks.py $INDIR $OUTDIR $SAMPLE
done
