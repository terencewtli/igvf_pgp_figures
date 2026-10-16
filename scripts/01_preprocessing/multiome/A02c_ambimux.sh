#!/bin/bash
#$ -cwd
#$ -o logs/A02c_ambimux.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A02c_ambimux
#$ -l h_data=1G,h_rt=1:00:00
#$ -pe shared 1
#$ -t 1-10:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

conda activate allcools

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/multiome
cd $PROJDIR

TEMPLATE=${REPO:-/u/project/cluo/terencew/claude/igvf/pgp/figures_clean/github/igvf_pgp_paper_figures}/scripts/01_preprocessing/multiome/templates/
CR_BASE=$PROJDIR/mapping/cr_arc/igvf_ref/default/

GTF=/u/project/cluo/terencew/reference/hg38_igvf/IGVF_hg38/genes/genes.gtf.gz
EXCL=/u/project/cluo/terencew/reference/hg38/bed/hg38-blacklist.v2_noheader.bed

SAMPLES=$PROJDIR/txt/samples.txt

# ID=1
ID=${SGE_TASK_ID}
SAMPLE=$(head -${ID} $SAMPLES | tail -1)

DEMUX_DIR=$PROJDIR/demux/regular/

GEX_BAM=$DEMUX_DIR/autosome_bam/gex/${SAMPLE}.reheader.bam
ATAC_BAM=$DEMUX_DIR/autosome_bam/atac/${SAMPLE}.reheader.bam

VCF=$PROJDIR/vcf/wgs/pgp_filt1.rm_missing.reheader.vcf.gz

DONORS=$PROJDIR/txt/donors.txt

INDIR=$PROJDIR/demux/wgs/
cd $INDIR

PEAKS=$PROJDIR/atac/peaks/cr_arc/${SAMPLE}.peaks.autosome.bed

JOINT_OUT=$INDIR/ambimux/joint/${SAMPLE}

qsub $TEMPLATE/ambimux.sh $GEX_BAM $ATAC_BAM $PEAKS $VCF $DONORS $GTF $EXCL $JOINT_OUT

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "
