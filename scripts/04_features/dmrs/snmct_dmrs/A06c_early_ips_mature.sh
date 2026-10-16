#!/bin/bash
#$ -cwd
#$ -o logs/A06c_early_ips_mature.$JOB_ID
#$ -j y
#$ -N A06c_early_ips_mature
#$ -l h_data=4G,h_rt=8:00:00
#$ -pe shared 4

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

ALLC_PATHS=$PROJDIR/txt/allc_table/tmp/ips.txt

ALLC_INDIR=$PROJDIR/allc/rna_cluster
ls $ALLC_INDIR/IPS*${DONOR}*.CGN-Merge.allc.tsv.gz > $ALLC_PATHS

ALLC_INDIR=/u/project/cluo/terencew/igvf/50_line/snmCT/pseudobulk_allc/allc/time/tmp
ls $ALLC_INDIR/*.CGN-Merge.allc.tsv.gz >> $ALLC_PATHS

CLUSTS=$PROJDIR/txt/allc_table/tmp/ips_clusts.txt
for f in $(cat $ALLC_PATHS);
do
    echo $(basename ${f%.CGN-Merge*});
done > $CLUSTS

mapfile -t TMP_CLUSTS < $CLUSTS
mapfile -t TMP_ALLC < $ALLC_PATHS

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

echo $CLUST_LIST
echo $ALLC_LIST

OUT=$PROJDIR/dmrs/methylpy/mature_ips/early_ips/merged/merged

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
