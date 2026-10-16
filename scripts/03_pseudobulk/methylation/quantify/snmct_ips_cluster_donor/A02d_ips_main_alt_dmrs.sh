#!/bin/bash
#$ -cwd
#$ -o logs/A02d_ips_main_alt_dmrs.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02d_ips_main_alt_dmrs
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-8:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=${SGE_TASK_ID}
ANNOTS=$PROJDIR/txt/allc_table/ips_cluster_donor.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/ips_cluster_donor/${ANNOT}.CGN-Merge.allc.tsv.gz

OUT=$PROJDIR/bed/features/ips_cluster_donor/${ANNOT}

INDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
DMRS=$INDIR/csv/dmrs/ips_cluster/IPS_alt_hypo_dms1.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'ips_dmrs' \
    --region_bed_paths $DMRS \
    --cpu 1 \
    --save_zero_cov

DMRS=$INDIR/csv/dmrs/mature_ips/dmrs_dms1.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'mature_ips_dmrs' \
    --region_bed_paths $DMRS \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
