#!/bin/bash
#$ -cwd
#$ -o logs/A02c_rna_cluster.$JOB_ID
#$ -j y
#$ -N A02c_rna_cluster
#$ -l h_data=8G,h_rt=16:00:00
#$ -pe shared 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CLUSTS=$PROJDIR/txt/allc_table/rna_cluster.txt

ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/rna_cluster_allc_paths.txt
ALLC_INDIR=$PROJDIR/allc/rna_cluster
ls $ALLC_INDIR/*.CGN-Merge.allc.tsv.gz > $ALLC_PATHS

mapfile -t TMP_CLUSTS < $CLUSTS
mapfile -t TMP_ALLC < $ALLC_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/rna_cluster/tmp_rna_cluster

time methylpy DMRfind \
  --allc-files $ALLC_LIST \
  --samples $CLUST_LIST \
  --mc-type 'CGN' \
  --num-procs 40 \
  --min-num-dms 1 \
  --output-prefix $OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
