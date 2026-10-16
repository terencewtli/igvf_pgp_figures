# Analysis code (cleaned 2026-10-09)

Cleaned analysis job scripts (`scripts/` at the repo root) and analysis notebooks (this folder) behind the manuscript.
The figure notebooks are in `ipynb/figures/`.

## Layout

Files are grouped by analysis stage, following the Methods and figure order, instead of by assay
(`10x/`, `snmct/`, `snm3c/`). `scripts/` and `ipynb/` share the same top-level folders.

| Folder | What it does | Manuscript |
|---|---|---|
| `00_genotypes/` | WGS VCF for the four lines, subset for demultiplexing | Methods: WGS and genotyping |
| `01_preprocessing/{multiome,snmct,snm3c}/` | mapping, demultiplexing, doublets, QC, ArchR arrows, single-nucleus allc / contact setup | Fig S1, Table S2 |
| `02_cell_states/{multiome,label_transfer,methylation,3c}/` | clusters, embeddings, label transfer across assays | Fig 1, S2, S3 |
| `03_pseudobulk/{methylation,atac,3c}/` | merging nuclei by cell state / donor / time point; quantifying regions | used throughout |
| `04_features/{pmds,dmrs,3c}/` | PMD calling, DMRs, scHiCluster imputation, TADs, loops, gene scores | Fig 2, 4, 5, 6 |
| `05_donor_variation/` | donor separation, global mCG, PMDs between lines | Fig 2A-I, S4, S5 |
| `06_within_line/` | per-line methylation clusters, Fisher enrichment, cell cycle | Fig 2J-M, S6 |
| `07_routes/{routes,degs,accessibility,methylation,3c}/` | productive / Fail1 / Fail2 routes: DEGs, peaks, motifs, SCENIC+, methylation, compartments | Fig 3, 4, S7, S8 |
| `08_gene_bins/` | late-activated genes vs PMDs, compartments, gene-body mCG | Fig 5, S9 |
| `09_ipsc_subtypes/` | iPSC-SE / iPSC-LE (early-iPSC nuclei only; see `09_ipsc_subtypes/README.md`): contact distance, TAD boundaries, DMRs, compartments | Fig 6, S10 |

Within a folder, notebooks are numbered in run order (`01_`, `02_`, ...). Job scripts keep their `A01a_`-style
names inside a subfolder per original step, because those names are also their SGE job and log names.

## What was changed

Only extraneous code was removed; no analysis logic was changed.

- Commented-out code, empty cells, repeated display cells (`adata`, `x.shape`, `!ls`) and duplicate command lines.
- Python cells whose results are never used later and that write, plot and display nothing.
- Cells that used a name before it was defined, when they only displayed it, and leftover exploratory tails after
  a notebook's last export. One rename to fix scoping: `igvf_adata` -> `igvf` in the Liu 2020 comparison.
- Notebook outputs are cleared, to keep the repo small (one notebook was 103 MB).
- Paths under the `~/project-cluo` symlink are written as `/u/project/cluo/terencew/...`.
- SGE job and log names match the new script names.
- Calls to helper scripts point at their copies here, via `${REPO:-<this repo>}/scripts/...`.

An inventory (kept outside this repo) lists every original script and notebook that was considered, where it went, and why anything was
left out:
- `keep`: copied here.
- `flag`: conflicts with the Methods; left out and described in the 2026-10-09 audit (kept outside this repo).
- `drop`: not used for the paper, superseded, or a re-run of failed tasks.

## 2026-10-14: iPSC-SE / iPSC-LE restricted to early-iPSC nuclei

The iPSC-SE / iPSC-LE analyses were rerun on early-iPSC nuclei only. This is an analysis change, unlike the
clean-up above. The rerun notebooks and job scripts are in `09_ipsc_subtypes/early_ipsc/` (notebooks and scripts).
The all-nuclei versions they replace were moved to `old_all_nuclei/` folders next to where they were. See
`09_ipsc_subtypes/README.md`.

## How "used for the paper" was decided

1. **Lineage:** the files read by the 2026-10-09 figure notebooks were traced back to the notebooks that write them
   (`final_figures/ipynb/*/python` exports, then `original/analysis`), and onward to their inputs.
2. **Methods steps:** steps the Methods describe were added where the tracer missed them, because their outputs
   are read through a variable path.
3. **Job scripts:** these were matched to Methods steps and to the directories the kept notebooks read.

Work done outside this code (subcluster differential peaks, ChromHMM, DREM, Horvath clock, CosMx) is listed in
the audit.
