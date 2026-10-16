# iPSC-SE / iPSC-LE (Fig 6D-J, Extended Data Fig 10B-O, Table S11)

iPSC-SE (`IPS_alt`) and iPSC-LE (`IPS_main`) are two 3C Leiden clusters of snm3C-seq nuclei, lifted over to
snmCT-seq by methylation (`01_liftover_3c_ips_subclusters_to_snmct`). Downstream comparisons use **only nuclei
labelled early-iPSC**: the RNA label in snmCT-seq and the transferred methylation label in snm3C-seq. There is no
sampling-day filter.

The first version of this analysis used every nucleus in the two clusters. That code is in `old_all_nuclei/` (and
`old_all_nuclei/` subfolders under `scripts/`) for reference. It is not what the current figures use.

## Run order

Notebooks are in `early_ipsc/`, job scripts are in `scripts/09_ipsc_subtypes/early_ipsc/`. Outputs go to
`/u/project/cluo/terencew/claude/igvf/pgp/ipsc_le_se_rerun` (`csv/`, `txt/`, `allc/`, `cooler/`, `juicer/`, ...).

| Step | Code | Output | Panels |
|---|---|---|---|
| 1 | `R01a_define_early_ipsc_nuclei` | early-iPSC LE/SE nucleus table, counts per group and donor | Table S2, Methods counts |
| 2 | `R01g_pseudobulk_lists_early_ipsc` | per-group allc (snmCT, CGN-Merge) and contact (snm3C) lists | |
| 3 | `B01c_allc_cgn_ips_cluster` → `B01d_dmrs_cgn_ips_cluster` | LE / SE methylation pseudobulks, methylpy DMRs | |
| 4 | `B02c_allc_cgn_ips_cluster_donor` | LE / SE × donor pseudobulks, 100 kb / 200 bp bins, PMD regions | |
| 5 | `B03a_contacts_ips_cluster` → `B03b_mcool_to_hic_ips_cluster` | LE / SE coolers (10 kb, 100 kb balanced) and KR `.hic` | |
| 6 | `B03c_downsample_le_hic` | LE contacts sampled to the SE total, `.hic` | Fig 6F |
| 7 | `R01b_rna_panels_early_ipsc` | RNA UMAP, pluripotency markers, trajectory and cell-cycle scores, DEGs | ED10 E-I |
| 8 | `R01c_contact_distance_early_ipsc` | per-nucleus contact-distance profiles | Fig 6E |
| 9 | `R01d_mcg_classifier_umap_nn_early_ipsc` | SE/LE classifier F1, methylation UMAP, same-donor neighbours | Fig 6G-J |
| 10 | `R01e_mature_ipsc_corr_early_ipsc` | correlation with mature iPSC (100 kb, ≥10x) | Fig 6H |
| 11 | `R01f_go_early_ipsc` | g:Profiler GO on DEGs (FDR < 0.05) | ED10J |
| 12 | `R03a_tad_boundaries_early_ipsc` | per-nucleus TopDom boundaries, differential 25 kb bins, GREAT input bed | ED10M, Table S11 |
| 13 | `B04a_great_diff_boundaries` → `R06a_great_diff_boundaries_early_ipsc` | GREAT terms (binom p < 1e-5, top 50) | ED10N |
| 14 | `R04a_compartments_4dn_early_ipsc` | E1 (100 kb) and correlation with 4DN iPSC | ED10L |
| 15 | `R05a_pmds_metagene_early_ipsc` | PMD metagene per subtype × donor | ED10K |
| 16 | `R07a_dmrs_tad_boundaries_early_ipsc` | hypo/hyper DMRs (>1 DMS), overlap with differential boundaries | ED10O, Table S11 |
| 17 | `R08b_nn_balanced_fixed_pcs_early_ipsc` | same-donor neighbours with equal nuclei per donor × group (500 subsets) | Fig 6J check |
| 18 | `R09a_export_final_figures_early_ipsc` | `final_figures/csv/figure5/*_early_ipsc.csv` read by `ipynb/figures/Figure_6` and `Figure_S10` | |

Steps 7-11 need only step 1. Step 12 needs step 1; steps 13 and 16 need step 12.

## Notes

- Notebooks with a `### check` or `published` cell compare against the published all-nuclei result. The
  differences are summarized in `ipsc_le_se_rerun/md/REGEN_DIFF.md`.
- The per-nucleus `*.CGN-Merge.allc.tsv.gz` files were read from the weekly NFS snapshot of
  `2023_YR2/snmCT/mc/allc/raw` (`weekly_2026-10-11_12_00_00_UTC`), because the live copies were removed.
- In the rerun, 6 of the 8 subtype × donor pseudobulks were built by merging full-context allc and then extracting
  CGN with strands merged. `B02c` merges the CGN-Merge files directly for all 8. These are equivalent: on IPS_main_C37,
  99.98% of CpGs have identical counts and total mC / coverage agree within 0.004%.
- GREAT `neg_log10p` is -log10 p. The all-nuclei notebook (`old_all_nuclei/06_check_ips_subtypes_great`) used the natural log.
- `02_plot_ips_subtypes_on_mcg_umap` is still upstream: `R09a` keeps its UMAP coordinates and restricts the labels to
  early-iPSC nuclei. `01` and `03` (per-nucleus contact distances, all nuclei) are also still upstream.
- `14_process_mature_ips_early_ips_dmrs` and `15_process_mature_ips_dmrs` (mature-iPSC DMRs), and the other
  `ips_cluster` job scripts outside `early_ipsc/` (bigwigs, loops, snm3C methylation pseudobulks, phase and
  per-donor DMRs, `snmct_ips_cluster*/A02a`, `A02c-e`) were not rerun. They use all nuclei and are not used in
  Fig 6 or Extended Data Fig 10.
