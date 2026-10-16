#!/bin/bash
#$ -cwd
#$ -o logs/A02a_get_feature_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02a_get_feature_allc
#$ -l h_data=2G,h_rt=2:00:00
#$ -pe shared 2
#$ -t 1-24:1

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

ANNOTS=$PROJDIR/txt/allc_table/rev_class.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/rev_class/${ANNOT}.CGN-Merge.allc.tsv.gz
OUT=$PROJDIR/bed/bins/rev_class/${ANNOT}

time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --bin_sizes 100000 5000 500 200 100 \
    --cpu 1 \
    --save_zero_cov

OUT=$PROJDIR/bed/features/rev_class/${ANNOT}

GENES=/u/project/cluo/terencew/reference/hg38_igvf/bed/genes/gencode.v43.autosome.dedup.names.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'genes' \
    --region_bed_paths $GENES \
    --cpu 1 \
    --save_zero_cov

PROMOTERS=/u/project/cluo/terencew/reference/hg38_igvf/bed/genes/ucsc.known_genes.promoters.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'promoters' \
    --region_bed_paths $PROMOTERS \
    --cpu 1 \
    --save_zero_cov

PEAKS=/u/project/cluo/terencew/igvf/2023_YR2/multiome/atac/peaks/chromhmm/justin.chromhmm.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'peaks' \
    --region_bed_paths $PEAKS\
    --cpu 1 \
    --save_zero_cov

INDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc
DMRS=$INDIR/csv/dmrs/rna_cluster/dmrs.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'dmrs' \
    --region_bed_paths $DMRS \
    --cpu 1 \
    --save_zero_cov

CLUSTER_DMRS=$INDIR/csv/dmrs/rna_cluster_donor/merged/cluster_specific_all.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'cluster_specific_dmrs' \
    --region_bed_paths $CLUSTER_DMRS \
    --cpu 1 \
    --save_zero_cov

DONOR_DMRS=$INDIR/csv/dmrs/rna_cluster_donor/merged/donor_specific_all.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'donor_specific_dmrs' \
    --region_bed_paths $DONOR_DMRS \
    --cpu 1 \
    --save_zero_cov

DONOR_LEIDEN_DMRS=$INDIR/csv/dmrs/donor_leiden/merged/unique_dmrs.dms1.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'donor_leiden_dmrs' \
    --region_bed_paths $DONOR_LEIDEN_DMRS \
    --cpu 1 \
    --save_zero_cov

###
E_REG=/u/project/cluo/terencew/igvf/2023_YR2/multiome/bed/scenic/eregulon.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'eregulon' \
    --region_bed_paths $E_REG \
    --cpu 1 \
    --save_zero_cov

D_REG=/u/project/cluo/terencew/igvf/2023_YR2/multiome/bed/scenic/dregulon.bed.gz
time allcools region --allc_path $ALLC \
    --output_prefix $OUT \
    --chrom_size_path $CHROM_SIZES \
    --mc_contexts 'CGN' \
    --region_bed_names 'dregulon' \
    --region_bed_paths $D_REG \
    --cpu 1 \
    --save_zero_cov

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
