# Versatile Alignment Tool 
<!-- ![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https://github.com/xuan13hao/VAT&count_bg=%2379C83D&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=true) -->
[![GitHub Downloads](https://img.shields.io/github/downloads/xuan13hao/VAT/total.svg?style=social&logo=github&label=Download)](https://github.com/xuan13hao/VAT/releases)


**VATAligner** (Versatile Alignment Tool) is a fast and efficient multi-purpose sequence aligner. It supports the alignment of both short and long nucleotide sequences, as well as protein homology searches, offering a flexible solution for various sequence analysis needs.
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

For a list of available options and command-line flags, refer to the detailed documentation in the [src/README.md](src/README.md) file.

## Pre-built Container (Apptainer/Singularity)

A ready-to-use container image is available for quick use:

[![Download SIF](https://img.shields.io/badge/Download%20SIF-Figshare-blue?logo=apptainer)](https://doi.org/10.6084/m9.figshare.29506208)

🔗 **Direct download**:  
[`VAT.sif`](https://figshare.com/ndownloader/files/59000968)

```bash
apptainer exec VAT.sif VAT --help
apptainer shell --no-home VAT.sif
