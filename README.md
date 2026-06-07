# pyEIF

Analysis and figure-generation scripts for the PNAS article:

> Wu, S. and Wagner, G. **Computational inference of eIF4F complex function and structure in human cancers.** *Proceedings of the National Academy of Sciences* 121(5), e2313589121 (2024). https://doi.org/10.1073/pnas.2313589121

The repository contains R and Python workflows used to reproduce the computational analyses and figures from the paper. The analyses focus on copy-number variation, RNA-seq expression, proteomics, pathway enrichment, survival analysis, protein-correlation networks, and DepMap dependency patterns related to the eIF4F translation-initiation complex in human cancers.

## Repository Contents

```text
pyEIF/
├── Script/
│   ├── Fig1.R          # TCGA copy-number analyses, enrichment, CNV plots, co-occurrence tests
│   ├── Fig1.py         # CNV density plots and Kaplan-Meier survival analysis
│   ├── Fig2.py         # RNA-seq/CNV integration, differential correlations, UMAP/PCA plots
│   ├── Fig2.R          # Heatmaps, cluster extraction, and Reactome enrichment for RNA correlations
│   ├── Fig3.py         # CCLE proteomics, DepMap, STRING/network analyses
│   ├── Fig3.R          # Heatmaps and enrichment analysis for proteomic correlations
│   ├── Load.R          # Shared R package imports, output folders, plotting defaults
│   ├── Pymodules.R     # Reticulate helper for installing Python dependencies
│   └── Setup.py        # Shared Python imports, plotting defaults, and directory settings
├── etc/
│   ├── init_data.py    # Python command-line helper for parsing TCGA CNV inputs
│   ├── input_data_adapters/
│   │   ├── tcga_cnv_parser.py
│   │   ├── org_hs_eg_db_lookup.py
│   │   └── *_tests.py
│   └── plotting/
│       └── gene_enrichment.py
└── LICENSE.md          # Apache License 2.0
```

## Analyses

### Figure 1 Workflows

`Script/Fig1.R` and `Script/Fig1.py` process TCGA pan-cancer copy-number data. They generate:

- TCGA CNV category and value tables.
- Top amplified, copy-gained, and homozygously deleted genes.
- Reactome pathway enrichment plots.
- CNV correlation matrices.
- CNV status plots across cancer types.
- eIF-gene co-occurrence analyses.
- Kaplan-Meier survival curves based on EIF3E and EIF4G1 copy-number status.

### Figure 2 Workflows

`Script/Fig2.py` and `Script/Fig2.R` combine TCGA/GTEx RNA-seq expression with TCGA CNV calls. They generate:

- Violin plots comparing RNA expression by EIF4G1 CNV status.
- Differential gene-correlation tables by CNV group.
- Clustered heatmaps for EIF4G1, EIF4A2, EIF3E, and EIF3H correlation programs.
- Reactome enrichment plots for correlation clusters.
- UMAP and PCA visualizations of expression programs.

### Figure 3 Workflows

`Script/Fig3.py` and `Script/Fig3.R` analyze CCLE proteomics, DepMap dependency data, and protein-interaction networks. They generate:

- Pairwise protein-correlation plots for eIF4F-related proteins.
- Proteomic correlation heatmaps and cluster-level Reactome enrichment.
- STRING-derived interaction networks for correlation clusters.
- Network centrality and community plots.
- CRISPR/RNAi dependency score distributions.
- CNV/dependency relationships for selected proteins.

## Data Sources

The scripts expect public datasets to be downloaded separately and placed in the configured data directory. Data files referenced by the code include:

- TCGA GISTIC2 copy-number threshold data:
  `Gistic2_CopyNumber_Gistic2_all_thresholded.by_genes`
- TCGA GISTIC2 copy-number value data:
  `Gistic2_CopyNumber_Gistic2_all_data_by_genes`
- TCGA phenotype table:
  `TCGA_phenotype_denseDataOnlyDownload.tsv`
- TCGA/GTEx RNA-seq table:
  `TcgaTargetGtex_RSEM_Hugo_norm_count`
- TCGA survival table:
  `Survival_SupplementalTable_S1_20171025_xena_sp`
- CCLE proteomics:
  `protein_quant_current_normalized.csv`
- CCLE sample annotation:
  `sample_info.csv`
- CCLE copy-number data:
  `CCLE_gene_cn.csv`
- DepMap CRISPR gene-effect data:
  `CRISPR_gene_effect.csv`
- DepMap RNAi dependency data:
  `D2_combined_gene_dep_scores.csv`
- STRING physical interaction data:
  `9606.protein.physical.links.detailed.v11.5.txt`
- Bioconductor human gene annotation SQLite database:
  `org.Hs.eg.db/inst/extdata/org.Hs.eg.sqlite`

The paper states that the datasets are publicly available and that the repository provides scripts for downloading or processing data from the relevant repositories.

## Environment

The workflows use both R and Python. A Conda environment is recommended because several dependencies come from Bioconductor, CRAN, PyPI, and Conda.

### Python Packages

Core Python packages used by the scripts include:

```text
absl-py
datatable
fastcluster
gseapy
heatmap-grammar
lifelines
matplotlib
matplotlib-venn
mygene
networkx
numpy
pandas
python-louvain
scikit-learn
scipy
seaborn
statannot
umap-learn
```

### R Packages

Core R packages used by the scripts include:

```text
AnnotationDbi
broom
circlize
clusterProfiler
ComplexHeatmap
corrplot
corrr
cowplot
data.table
DescTools
DOSE
dplyr
enrichplot
eulerr
forcats
ggnewscale
ggplot2
grid
HH
likert
limma
magrittr
org.Hs.eg.db
RColorBrewer
ReactomePA
readr
reshape2
reticulate
stringr
tibble
tidyverse
xlsx
```

Some of these packages are available from Bioconductor rather than CRAN.

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/a3609640/pyEIF.git
   cd pyEIF
   ```

2. Create a Python/R environment using Conda or your preferred environment manager.

3. Install the required Python and R packages.

4. Download the public data files listed above into a local data directory.

5. Update the local paths in:

   ```text
   Script/Load.R
   Script/Setup.py
   Script/Fig1.py
   Script/Fig2.py
   Script/Fig3.py
   Script/Fig1.R
   Script/Fig2.R
   Script/Fig3.R
   ```

   The original scripts contain absolute paths from the author environment, such as:

   ```text
   ~/Documents/Bioinformatics_analysis/eIF4G-analysis/eIF4G_data
   ~/Documents/Bioinformatics_analysis/eIF4G-analysis/eIF4G_output
   /home/suwu/github/pyEIF/Script/*.R
   ```

   Replace these with paths that match your local clone, data directory, and output directory.

6. Create or confirm the output directory structure. `Script/Load.R` creates:

   ```text
   Fig1/
   Fig2/
   Fig3/
   Fig4/
   ProcessedData/
   ```

## Usage

The figure workflows are script based. Run them from the repository root after configuring local paths and installing dependencies.

### Figure 1

```bash
Rscript Script/Fig1.R
python Script/Fig1.py
```

`Fig1.py` calls `Fig1.R` internally in the original code, so avoid duplicate runs if you have already generated the R outputs.

### Figure 2

```bash
python Script/Fig2.py
Rscript Script/Fig2.R
```

`Fig2.py` writes processed correlation tables under `ProcessedData/`. `Fig2.R` consumes those tables to generate heatmaps, cluster files, and pathway plots.

### Figure 3

```bash
python Script/Fig3.py
Rscript Script/Fig3.R
```

`Fig3.py` writes proteomic correlation and network-analysis inputs under `ProcessedData/`. `Fig3.R` consumes those outputs for heatmap clustering and Reactome enrichment.

### TCGA CNV Initialization Helper

The `etc/init_data.py` helper can parse TCGA CNV inputs and write selected processed outputs:

```bash
python etc/init_data.py \
  --data_directory=/path/to/eIF4G_data \
  --output_directory=/path/to/eIF4G_output
```

Show available options with:

```bash
python etc/init_data.py --help
```

## Outputs

Generated files are written to the configured output directory, typically under:

```text
Fig1/
Fig2/
Fig3/
ProcessedData/
```

Outputs include PDF figures, CSV intermediate tables, and Excel workbooks with top genes, pathway enrichment results, and co-occurrence statistics.

## Reproducibility Notes

- The scripts are designed to reproduce the computational analyses reported in the PNAS paper, but they are not packaged as a command-line application.
- Several scripts depend on intermediate files generated by earlier scripts.
- Local paths must be edited before use.
- Some plots may vary slightly across package versions, random seeds, and clustering implementations.
- Large public datasets are not committed to this repository and must be downloaded separately.
- The AlphaFold multimer structure-prediction work described in the paper was run externally on a GPU cluster and is not represented as a standalone script in this repository.

## Citation

If you use this repository or adapt its workflows, please cite:

```bibtex
@article{wu2024computational,
  title = {Computational inference of eIF4F complex function and structure in human cancers},
  author = {Wu, Su and Wagner, Gerhard},
  journal = {Proceedings of the National Academy of Sciences},
  volume = {121},
  number = {5},
  pages = {e2313589121},
  year = {2024},
  doi = {10.1073/pnas.2313589121}
}
```

## License

This repository is distributed under the Apache License 2.0. See `LICENSE.md` for details.
