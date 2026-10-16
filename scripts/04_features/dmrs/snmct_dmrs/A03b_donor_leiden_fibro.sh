#!/bin/bash
#$ -cwd
#$ -o logs/A03b_donor_leiden_fibro.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A03b_donor_leiden_fibro
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

CLUSTS=$PROJDIR/txt/allc_table/donor_leiden_fibro.txt

DONOR_CLUSTS=$PROJDIR/txt/allc_table/tmp/${DONOR}_donor_leiden_fibro.txt

grep $DONOR $CLUSTS > $DONOR_CLUSTS

ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/${DONOR}_donor_leiden_fibro_allc_paths.txt
ALLC_INDIR=$PROJDIR/allc/donor_leiden_fibro
for CLUST in $(cat $DONOR_CLUSTS);
do
    echo $ALLC_INDIR/${CLUST}.CGN-Merge.allc.tsv.gz
done > $ALLC_PATHS

mapfile -t TMP_CLUSTS < $DONOR_CLUSTS
mapfile -t TMP_ALLC < $ALLC_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/donor_leiden_fibro/${DONOR}/${DONOR}

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
