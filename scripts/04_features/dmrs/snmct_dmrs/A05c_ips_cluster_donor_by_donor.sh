#!/bin/bash
#$ -cwd
#$ -o logs/A05c_ips_cluster_donor_by_donor.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A05c_ips_cluster_donor_by_donor
#$ -l h_data=4G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-4:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
DONORS=$PROJDIR/txt/donors.txt
DONOR=$(head -${ID} $DONORS | tail -1)

CLUSTS=$PROJDIR/txt/allc_table/ips_cluster.txt

ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/ips_cluster_donor.txt

ALLC_INDIR=$PROJDIR/allc/ips_cluster_donor
ls $ALLC_INDIR/*.CGN-Merge.allc.tsv.gz > $ALLC_PATHS

TMP_PATHS=$PROJDIR/txt/allc_table/tmp/ips_cluster_donor_${DONOR}.txt
grep $DONOR $ALLC_PATHS > $TMP_PATHS

mapfile -t TMP_CLUSTS < $CLUSTS
mapfile -t TMP_ALLC < $TMP_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/ips_cluster_donor/${DONOR}/$DONOR

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
