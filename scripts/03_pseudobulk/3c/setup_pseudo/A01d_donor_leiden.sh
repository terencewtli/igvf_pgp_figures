#!/bin/bash
#$ -cwd
#$ -o logs/A01d_donor_leiden.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01d_donor_leiden
#$ -l h_data=4G,h_rt=8:00:00
#$ -pe shared 8
#$ -t 1-49:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic
cd $PROJDIR

# ID=10
ID=$SGE_TASK_ID
SAMPLES=$PROJDIR/txt/donor_leiden.txt
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

CONTACT_LIST=$PROJDIR/txt/pseudobulk/donor_leiden/${SAMPLE}.txt

TMPDIR=/u/project/cluo_scratch/terencew/igvf/2023_YR2/snm3C/pseudobulk_hic

OUT=$TMPDIR/merged_contacts/raw/donor_leiden/${SAMPLE}.tsv

time for CONTACT in $(cat $CONTACT_LIST);
do
    zcat $CONTACT;
done | \
    awk -v OFS='\t' '{print $1,$2,$3,$4,1}' | \
  sort -S 2G -k1,1 -k2,2n -k3,3 -k4,4n > $OUT

###

BINS=/u/project/cluo/terencew/reference/hg38_igvf/bed/windows/10kb/GRCh38.10kb.bed
CONTACTS=$TMPDIR/merged_contacts/raw/donor_leiden/${SAMPLE}.tsv
COOL=$TMPDIR/merged_contacts/cooler/donor_leiden/${SAMPLE}.cool

time cooler cload pairs \
    --assembly hg38 \
    -c1 1 -p1 2 -c2 3 -p2 4 \
    $BINS $CONTACTS $COOL

###

COOL=$TMPDIR/merged_contacts/cooler/donor_leiden/${SAMPLE}.cool
time cooler zoomify \
  -r 100000,1000000 $COOL

### balance

RES=100000
COOL=$TMPDIR/merged_contacts/cooler/donor_leiden/${SAMPLE}.mcool

time cooler balance -f -p 40 ${COOL}::/resolutions/${RES}

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
