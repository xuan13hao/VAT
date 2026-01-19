# VAT Aligner 

## Overview

VAT (Versatile Alignment Tool) is a high-performance sequence alignment tool supporting multiple alignment modes for DNA and protein sequences.

## Commands

### makevatdb
Build VAT database from FASTA file
```bash
VAT makevatdb --in <input.fa> --dbtype nucl/prot
```
- Creates `<input.fa.vatf>` database file

### dna
DNA sequence alignment with various modes

### protein
Protein sequence alignment

### blastx
Translate DNA query against protein database

### dna2pro
Convert DNA to protein

### view
View VAT alignment archive (vaa) formatted file

## DNA Alignment Modes

### 1. WGS Mode (Whole Genome Sequencing)
High-performance alignment for whole genome sequencing data. Supports both short and long reads.

**Usage:**
```bash
./VAT makevatdb --in reference.fa --dbtype nucl

./VAT dna -d reference.fa -q reads.fa --wgs -o output.sam -f sam -p 8

./VAT dna -d reference.fa -q long_reads.fa --wgs --long -o output.sam -f sam

./VAT dna -d reference.fa -q reads.fa --wgs -S 15 -o output.sam -f sam
```
**Parameters:**
- `--wgs`: Enable whole genome sequencing mode
- `--long`: Enable long read mode (default: short reads)
- `-S, --seed_len`: K-mer size (default: 15)
---

### 2. Splice Alignment Mode
RNA-seq splice-aware alignment for detecting intron-exon boundaries and alternative splicing.

**Usage:**
```bash
./VAT makevatdb --in reference.fa --dbtype nucl

./VAT dna -d reference.fa -q rna_reads.fa --splice -o output.sam -f sam -p 8

./VAT dna -d reference.fa -q long_rna_reads.fa --splice --long -o output.sam -f sam
```
**Parameters:**
- `--splice`: Enable splice-aware alignment
- `--long`: Enable long read mode for RNA-seq
- `-S, --seed_len`: K-mer size for alignment
---

### 3. Circular RNA Mode
Detects circular RNA (circRNA) structures with back-spliced junctions.

**Usage:**
```bash
./VAT dna -d reference.fa -q rna_reads.fa --circ -o output.sam -f sam -p 8
```
### 4. DNA Homology Mode
Alignment mode optimized for detecting homologous sequences with evolutionary relationships.

**Usage:**
```bash
./VAT dna -d reference.fa -q query.fa --dnah -o output.tab -f tab -p 8
```

### 5. Whole Genome Alignment (WGA)
Whole genome alignment mode.

**Usage:**
```bash
./VAT dna -d reference.fa -q query.fa --wga -a output -p 32
./VAT view -a output.vatr -o output.tab -f tab
```
---

### 6. Metagenomic Mode
Metagenomic sequencing data analysis.

**Usage:**
```bash
./VAT dna -d reference.fa -q metagenomic_reads.fa --metagenomic -o output.tab -f tab -p 8
```

## Protein Alignment

### Standard Protein Alignment
```bash
./VAT makevatdb --in proteins.fa --dbtype prot

./VAT protein -d proteins.fa -q queries.fa -o output.tab -f tab -p 8
```

## Blastx Mode

Translate DNA query sequences and align against protein database.

**Usage:**
```bash
./VAT makevatdb --in proteins.fa --dbtype prot

./VAT blastx -d proteins.fa -q dna_query.fa -a output -p 8

./VAT view -a output.vatr -o output.tab -f tab
```
## Common Parameters

### General Options
- `-p, --threads`: Number of CPU threads (default: 4)
- `-d, --db`: Database file
- `-q, --query`: Query file
- `-o, --out`: Output file
- `-a, --vaa`: Archive (vatr) file
- `-f, --outfmt`: Output format (tab/sam/paf/pairwise, default: tab)

### Alignment Options
- `-S, --seed_len`: Seed length (default: 16 for DNA, 8 for protein)
- `--match`: Match score (default: 5)
- `--mismatch`: Mismatch penalty (default: -4)
- `--gapopen`: Gap open penalty
- `--gapextend`: Gap extension penalty
- `-e, --evalue`: Maximum e-value (default: 0.001)
- `-k, --maxtarget_seqs`: Maximum target sequences (default: 25)
- `--report_id`: Minimum identity% to report (default: 0)

### Advanced Options
- `--xdrop`: X-drop for ungapped alignment (default: 18)
- `-X, --gapped_xdrop`: X-drop for gapped alignment (default: 18)
- `-N, --num_shapes`: Number of seed shapes (0 = all available, for protein)
---
