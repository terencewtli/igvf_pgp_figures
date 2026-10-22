# Goal of repository

This repository contains a subset of the code used to analyze data and generate figures for the following manuscript:

> **Epigenomic heterogeneity and spatial organization during human reprogramming**
>
> Terence W. Li<sup>1,2,3,\*</sup>, Justin Langerman<sup>4,\*</sup>, Cuining Liu<sup>1,3,\*</sup>, Yu Sun<sup>4,\*</sup>, Mohammad S. Baig<sup>1,5</sup>, Gianna Kim<sup>1</sup>, Jingyuan Fu<sup>4,6</sup>, Rayyan Irfan Ghoor<sup>1</sup>, Yi Zhang<sup>1</sup>, Zach Von Behren<sup>1</sup>, Min Jen Tsai<sup>1</sup>, Malina Elena Cantemir<sup>1</sup>, Kevin D. Abuhanna<sup>1,5</sup>, Edward Chen<sup>1</sup>, Jon Paino<sup>6</sup>, Gideon Shaked<sup>4</sup>, Lily Zhao<sup>4</sup>, Lisa Barooah<sup>4</sup>, Amy Sun<sup>4</sup>, Andrea Garcia Angulo<sup>4</sup>, Alexander Lee<sup>4</sup>, Sophia Peavy<sup>4</sup>, Eleazar Eskin<sup>1,2,6</sup>, Noah Zaitlen<sup>1,2,7</sup>, Brunilda Balliu<sup>2,8,9,†</sup>, Jason Ernst<sup>2,4,6,†</sup>, Chongyuan Luo<sup>1,†</sup>, Kathrin Plath<sup>4,†</sup>
>
> <sup>\*</sup> Equal contribution &nbsp;·&nbsp; <sup>†</sup> Corresponding authors
>

[https://www.biorxiv.org/content/10.64898/2026.10.15.757424v1](https://www.biorxiv.org/content/10.64898/2026.10.15.757424v1)

## Data

All data are publicly available from the [IGVF Data Portal](https://data.igvf.org).
See the [project page](https://ucla-igvf-pgp-reprogramming.pages.dev/) to obtain download links to different components of the manuscript.

## Contents
- [`ipynb/figures/`](ipynb/figures): one R notebook per figure (Figures 1–4, 6 and S1–S8, S10), with panels labeled by letter (e.g. `### C: ...`). Schematics and genome browser views are not included.
- [`ipynb/analysis/`](ipynb/analysis): Jupyter notebooks organized by analysis type to produce figures.
- [`scripts/`](scripts/): bash scripts organized by analysis type to produce figures.

Notebooks use an R 4.1.0 kernel; each ends with `sessionInfo()` listing package versions. Python conda environment primarily used for Jupyter notebooks is supplied as well.
