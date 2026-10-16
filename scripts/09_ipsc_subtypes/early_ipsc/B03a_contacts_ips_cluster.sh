#!/bin/bash
#$ -cwd
#$ -o logs/B03a_contacts_ips_cluster.$JOB_ID.$TASK_ID
#$ -j y
#$ -N B03a_contacts_ips_cluster
#$ -l h_data=8G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-2
#$ -tc 2

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate mapping

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR

# ID=1
ID=$SGE_TASK_ID
SAMPLE=$(head -${ID} txt/contacts/ips_cluster.txt | tail -1)
TMPDIR=/u/project/cluo_scratch/terencew/claude/ipsc_le_se_rerun/raw_contacts
BINS=/u/project/cluo/terencew/reference/hg38_igvf/bed/windows/10kb/GRCh38.10kb.bed

# same steps as 03_pseudobulk/3c/setup_pseudo/old_all_nuclei/A01e_ips_cluster.sh, early-iPSC snm3C nuclei only (lists from early_ipsc/R01g)
time for CONTACT in $(cat txt/contacts/ips_cluster/${SAMPLE}.txt);
do
    zcat $CONTACT;
done | \
    awk -v OFS='\t' '{print $1,$2,$3,$4,1}' | \
    sort -S 6G -T $TMPDIR -k1,1 -k2,2n -k3,3 -k4,4n > $TMPDIR/${SAMPLE}.tsv

time cooler cload pairs --assembly hg38 -c1 1 -p1 2 -c2 3 -p2 4 \
    $BINS $TMPDIR/${SAMPLE}.tsv cooler/ips_cluster/${SAMPLE}.cool
time cooler zoomify -r 100000,1000000 cooler/ips_cluster/${SAMPLE}.cool
time cooler balance -f -p 4 cooler/ips_cluster/${SAMPLE}.mcool::/resolutions/100000
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date`
