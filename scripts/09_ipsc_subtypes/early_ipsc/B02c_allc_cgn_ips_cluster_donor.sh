#!/bin/bash
#$ -cwd
#$ -o logs/B02c_allc_cgn_ips_cluster_donor.$JOB_ID.$TASK_ID
#$ -j y
#$ -N B02c_allc_cgn_ips_cluster_donor
#$ -l h_data=8G,h_rt=8:00:00
#$ -pe shared 4
#$ -t 1-8
#$ -tc 8

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s` `date`
source ~/.bashrc
conda activate allcools

PROJDIR=/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun
cd $PROJDIR
export XDG_CACHE_HOME=/u/project/cluo_scratch/terencew/claude/ipsc_le_se_rerun/cache_c$SGE_TASK_ID

# early-iPSC snmCT nuclei per subtype x donor (8 groups); lists from early_ipsc/R01g
# merges the original per-nucleus CGN-Merge allc from the weekly_2026-10-11 snapshot
# (in the rerun 6 of the 8 groups were built by merging full-context allc and then extracting CGN;
#  checked on IPS_main_C37: 99.98% of CpGs identical, total mC/coverage within 0.004%)
# ID=1
ID=$SGE_TASK_ID
ANNOT=$(head -${ID} txt/allc_table_cgn/ips_cluster_donor.txt | tail -1)
CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes
PBDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
ALLC=allc/ips_cluster_donor_cgn/${ANNOT}.CGN-Merge.allc.tsv.gz

time allcools merge --allc_paths txt/allc_table_cgn/ips_cluster_donor/${ANNOT}.txt \
    --output_path $ALLC \
    --chrom_size_path $CHROM_SIZES \
    --cpu 4
time tabix -f -b 2 -e 2 -s 1 $ALLC

# 100 kb / 200 bp bins (Fig 6H checks, ED10K) and PMD regions (ED10K)
time allcools region --allc_path $ALLC \
    --output_prefix bed/bins/ips_cluster_donor/${ANNOT} \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --bin_sizes 100000 200 \
    --cpu 1 --save_zero_cov

time allcools region --allc_path $ALLC \
    --output_prefix bed/pmds/ips_cluster_donor/${ANNOT} \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'start_pmds' 'pmds_windows' \
    --region_bed_paths $PBDIR/pmds/dnmtools/rna_cluster_donor/merged/start_merged.filt_mcg.sorted.bed.gz $PBDIR/csv/pmds/rna_cluster_donor/start.filt_mcg.windows.bed.gz \
    --cpu 1 --save_zero_cov
echo "Job $JOB_ID.$SGE_TASK_ID ended on:   " `date`
