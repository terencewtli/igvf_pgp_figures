#!/bin/bash
#$ -cwd
#$ -o logs/A07b_ips_cluster_phase_by_phase.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A07b_ips_cluster_phase_by_phase
#$ -l h_data=4G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-3:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
PHASES=$PROJDIR/txt/phases.txt
PHASE=$(head -${ID} $PHASES | tail -1)

CLUSTS=$PROJDIR/txt/allc_table/ips_cluster.txt

ALLC_INDIR=$PROJDIR/allc/ips_cluster_phase

# build allc-file list in the same order as CLUSTS so --allc-files lines up
# silently swap the pairing)
mapfile -t TMP_CLUSTS < $CLUSTS
TMP_ALLC=()
for c in "${TMP_CLUSTS[@]}"; do
    TMP_ALLC+=("$ALLC_INDIR/${c}_${PHASE}.CGN-Merge.allc.tsv.gz")
done

CLUST_LIST=$(echo "${TMP_CLUSTS[@]}")
ALLC_LIST=$(echo "${TMP_ALLC[@]}")

OUT=$PROJDIR/dmrs/methylpy/ips_cluster_phase/${PHASE}/$PHASE

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
