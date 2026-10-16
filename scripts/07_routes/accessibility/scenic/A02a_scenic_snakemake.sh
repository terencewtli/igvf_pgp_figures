#!/bin/bash
#$ -cwd
#$ -o logs/A02a_scenic_snakemake.$JOB_ID
#$ -j y
#$ -N A02a_scenic_snakemake
#$ -l h_data=30G,h_rt=4:00:00,highp
#$ -pe shared 20

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate scenicplus

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome/
cd $PROJDIR

INDIR=$PROJDIR/gene_networks/scenic/Snakemake
cd $INDIR

time snakemake --cores 20

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
