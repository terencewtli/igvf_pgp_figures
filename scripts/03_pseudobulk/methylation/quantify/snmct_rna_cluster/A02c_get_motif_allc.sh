#!/bin/bash
#$ -cwd
#$ -o logs/A02c_get_motif_allc.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02c_get_motif_allc
#$ -l h_data=1G,h_rt=2:00:00
#$ -pe shared 1
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate mapping

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snmCT/pseudobulk_allc/
cd $PROJDIR

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

# ID=1
ID=$SGE_TASK_ID

ANNOTS=$PROJDIR/txt/allc_table/rna_cluster.txt
ANNOT=$(head -${ID} $ANNOTS | tail -1)

ALLC=$PROJDIR/allc/rna_cluster/${ANNOT}.CGN-Merge.allc.tsv.gz

INDIR=/u/project/cluo/terencew/programs/homer/data/bed/vertebrates

MOTIFS=$PROJDIR/txt/motifs/homer.txt

for MOTIF in $(cat $MOTIFS);
do
  echo $MOTIF
  MOTIF_PATH=$INDIR/${MOTIF}.bed.gz
  OUT=$PROJDIR/bed/motifs/rna_cluster/${ANNOT}
  time allcools region --allc_path $ALLC \
      --output_prefix $OUT \
      --chrom_size_path $CHROM_SIZES \
      --mc_contexts 'CGN' \
      --region_bed_names $MOTIF \
      --region_bed_paths $MOTIF_PATH \
      --cpu 1 \
      --save_zero_cov
done

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
