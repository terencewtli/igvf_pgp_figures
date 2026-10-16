#!/bin/bash
#$ -cwd
#$ -o logs/B01c_allc_cgn_ips_cluster.$JOB_ID.$TASK_ID
#$ -j y
#$ -N B01c_allc_cgn_ips_cluster
#$ -l h_data=8G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-2
#$ -tc 2

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate allcools

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR

# early-iPSC snmCT nuclei per iPSC-LE (IPS_main) / iPSC-SE (IPS_alt); lists from early_ipsc/R01g
# merges the original per-nucleus CGN-Merge allc (read-only NFS snapshot, weekly_2026-10-11)
# ID=1
ID=$SGE_TASK_ID
ANNOT=$(head -${ID} txt/allc_table_cgn/ips_cluster.txt | tail -1)
CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes
ALLC=allc/ips_cluster_cgn/${ANNOT}.CGN-Merge.allc.tsv.gz

time allcools merge --allc_paths txt/allc_table_cgn/ips_cluster/${ANNOT}.txt \
    --output_path $ALLC \
    --chrom_size_path $CHROM_SIZES \
    --cpu 4
time tabix -f -b 2 -e 2 -s 1 $ALLC
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date`
