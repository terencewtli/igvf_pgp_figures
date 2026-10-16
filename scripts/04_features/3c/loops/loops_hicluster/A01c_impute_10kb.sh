#!/bin/bash
#$ -cwd
#$ -o logs/A01c_impute_10kb.$JOB_ID.$TASK_ID
#$ -j y
#$ -N A01c_impute_10kb
#$ -l h_data=2G,h_rt=20:00:00
#$ -pe shared 6
#$ -t 1-1895:1

echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `date `
echo " "

source ~/.bashrc

### dangerous gameeeee
conda activate hiclusterv2

PROJDIR=/u/project/cluo/terencew/igvf/2023_YR2/snm3C/hicluster/
cd $PROJDIR

# ID=1
ID=${SGE_TASK_ID}
printf -v BATCH "%04d" $(($ID - 1))

CONTACTS=$PROJDIR/txt/batch/impute_10kb/${BATCH}.txt

CHROM_SIZES=/u/project/cluo/terencew/reference/hg38_igvf/GRCh38.autosomal.chromsizes

RES=10000

### impute params
MODE=pad2_std1_rp0.5_sqrtvc
WIN=30000000
STEP=10000000
DIST=10050000

INDIR=$PROJDIR/old_hicluster/cell_matrix/10kb_resolution/
OUTDIR=$PROJDIR/old_hicluster/imputed_matrix/10kb_resolution/

### altogether takes about 1 hour per cell

time for CONTACT in $(cat $CONTACTS);
do
  CELL=$(basename ${CONTACT%.contact*})
  time for c in `seq 1 12`;
  do
      time hicluster impute-cell --indir $INDIR/chr${c}/ \
        --outdir $OUTDIR/chr${c}/ \
        --cell $CELL --window_size $WIN \
        --step_size $STEP --chrom ${c} \
        --res $RES --pad 2 --output_dist $DIST \
        --mode $MODE --chrom_file $CHROM_SIZES;

      time hicluster loop-bkg-cell --indir $OUTDIR/ \
        --cell $CELL --chrom ${c} --res $RES \
        --impute_mode $MODE;
  done

  time for c in `seq 13 22`;
  do
      ### only difference is that
      ### there's no step size for smaller chroms
      time hicluster impute-cell --indir $INDIR/chr${c}/ \
        --outdir $OUTDIR/chr${c}/ \
        --cell $CELL --window_size $WIN \
        --chrom ${c} \
        --res $RES --pad 2 --output_dist $DIST \
        --mode $MODE --chrom_file $CHROM_SIZES;

      time hicluster loop-bkg-cell --indir $OUTDIR/ \
        --cell $CELL --chrom ${c} --res $RES \
        --impute_mode $MODE;
  done
done
