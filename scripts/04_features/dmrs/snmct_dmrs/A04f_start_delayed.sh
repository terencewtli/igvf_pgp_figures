#!/bin/bash
#$ -cwd
#$ -o logs/A04f_start_delayed.$JOB_ID
#$ -j y
#$ -N A04f_start_delayed
#$ -l h_data=4G,h_rt=4:00:00
#$ -pe shared 4

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CLUSTS=$PROJDIR/txt/dmrs/start_delayed.txt

ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/start_delayed.txt
ALLC_INDIR=$PROJDIR/allc/rna_cluster

for f in $(cat $CLUSTS);
do
    ls $ALLC_INDIR/${f}.CGN-Merge.allc.tsv.gz
done > $ALLC_PATHS

mapfile -t TMP_CLUSTS < $CLUSTS
mapfile -t TMP_ALLC < $ALLC_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/rna_cluster/fail_traj/start_delayed/

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
