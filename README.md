# Versatile Alignment Tool 
<!-- ![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https://github.com/xuan13hao/VAT&count_bg=%2379C83D&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=true) -->
[![GitHub Downloads](https://img.shields.io/github/downloads/xuan13hao/VAT/total.svg?style=social&logo=github&label=Download)](https://github.com/xuan13hao/VAT/releases)


**VATAligner** (Versatile Alignment Tool) is a fast and efficient multi-purpose sequence aligner. It supports the alignment of both short and long nucleotide sequences, as well as protein homology searches, offering a flexible solution for various sequence analysis needs.


## Requirements

**VAT requires hardware support for AVX2 (Advanced Vector Extensions 2)**. AVX2 is a CPU instruction set extension that enables high-performance vectorized operations, which VAT uses to accelerate sequence alignment.

To check if your system supports AVX2:
```bash
# On Linux
grep -o 'avx2' /proc/cpuinfo | head -1

# Or check CPU flags
lscpu | grep -i avx2
```

Most modern CPUs (Intel Haswell and later, AMD Excavator and later) support AVX2. If AVX2 is not available, VAT will not run.

<!-- 
## Prerequisites
Required for zlib and Boost
```console
dnf install zlib zlib-devel
dnf install boost-devel
``` -->

## Features
- Supports both DNA and protein sequence alignments.
- High-performance alignment with multi-threading capabilities.
- Flexible input formats for FASTA/FASTQ sequences.
- Suitable for large-scale sequence analysis in genomics and protein.

## Performance

**VATAligner** leverages multi-threading to accelerate the alignment process for large datasets. 

## Data Availability

For information on data preparation and access, please refer to the [data_preparation/README.md](data_preparation/README.md) file.

## Help and Options

For a list of available options and command-line flags, refer to the detailed documentation in the [src/README.md](src/README.md) file or [`data_preparation/VATmanual.pdf`](data_preparation/VATmanual.pdf)

## Small test (quick benchmark)

Run a small benchmark on the included test cases:

```bash
git clone https://github.com/xuan13hao/VAT.git
cd VAT
cd Benchmark_scripts
bash benchmark_vat.sh
```
<!-- ## Single-cell RNA-sequencing analysis pipeline
**scVAT**: An nf-core single-cell RNA-sequencing analysis pipeline supporting both short and long reads (https://github.com/xuan13hao/scVAT).

## Metagenomic taxonomic classification pipeline
**taxprofilerVAT** (formerly nf-core/taxprofiler) is a bioinformatics best-practice analysis pipeline for taxonomic classification and profiling of shotgun short- and long-read metagenomic data ([https://github.com/xuan13hao/taxprofilerVAT](https://github.com/xuan13hao/taxprofilerVAT)). -->

## Citation

If you use VAT in your research, please cite:

Hao Xuan, Hongyang Sun, Xiangtao Liu, Hanyuan Zhang, Jun Zhang, Cuncong Zhong. A general and extensible algorithmic framework to biological sequence alignment across scales and applications. *bioRxiv* 2026.01.28.702355; doi: [https://doi.org/10.64898/2026.01.28.702355](https://doi.org/10.64898/2026.01.28.702355)

<!-- ## Pre-built Container (Apptainer/Singularity)

A ready-to-use container image is available for quick use:

[![Download SIF](https://img.shields.io/badge/Download%20SIF-Figshare-blue?logo=apptainer)](https://doi.org/10.6084/m9.figshare.29506208)

🔗 **Direct download**:  
[`VAT.sif`](https://figshare.com/ndownloader/files/59002129)

```bash
apptainer exec VAT.sif VAT --help
apptainer shell --no-home VAT.sif -->
