#!/bin/bash
#$ -cwd
#$ -o logs/A03a_donor_leiden.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A03a_donor_leiden
#$ -l h_data=8G,h_rt=16:00:00
#$ -pe shared 8
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

CLUSTS=$PROJDIR/txt/allc_table/donor_leiden.txt

DONOR_CLUSTS=$PROJDIR/txt/allc_table/tmp/${DONOR}_donor_leiden.txt

grep $DONOR $CLUSTS > $DONOR_CLUSTS

ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/${DONOR}_donor_leiden_allc_paths.txt
ALLC_INDIR=$PROJDIR/allc/donor_leiden
for CLUST in $(cat $DONOR_CLUSTS);
do
    echo $ALLC_INDIR/${CLUST}.CGN-Merge.allc.tsv.gz
done > $ALLC_PATHS

mapfile -t TMP_CLUSTS < $DONOR_CLUSTS
mapfile -t TMP_ALLC < $ALLC_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/donor_leiden/${DONOR}/${DONOR}

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
