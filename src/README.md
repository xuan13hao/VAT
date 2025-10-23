# VATAligner

**VATAligner** (Versatile Alignment Tool) is a high-performance, multi-purpose tool designed for DNA and protein sequence alignments. It supports a wide range of alignment tasks, including nucleotide and protein database creation, homology searches, splice alignments, and whole-genome sequencing.

---

## Features

- **Fast and Efficient**: Multi-threaded support for large-scale data processing.
- **Versatile**: DNA and protein sequence alignment with advanced options.
- **Flexible**: Fine-tune parameters to customize alignment for specific applications.
- **Comprehensive Options**: Supports chimera alignment, circular DNA alignment, splice alignments, and more.

---

## Command-line Options

### General Options
| Option               | Description                                   |
|----------------------|-----------------------------------------------|
| `-h`, `--help`        | Show help message.                           |
| `-p`, `--threads`     | Number of CPU threads (default: 4).          |
| `-d`, `--db`          | Specify the database file.                   |
| `-a`, `--vaa`         | VAT alignment archive (vatr) file.           |
| `--dbtype`            | Database type: `nucl` (nucleotide) or `prot` (protein). |

---

### Makedb Options
| Option              | Description                                      |
|---------------------|--------------------------------------------------|
| `-i`, `--in`        | Input reference file in FASTA format.            |

---

### Aligner Options
| Option                   | Description                                                                                  |
|--------------------------|----------------------------------------------------------------------------------------------|
| `-q`, `--query`           | Input query file.                                                                            |
| `-k`, `--maxtarget_seqs`  | Maximum number of target sequences to report (default: 25).                                  |
| `--top`                   | Report alignments within the top percentage range of alignment scores (default: 100).         |
| `-e`, `--evalue`          | Maximum e-value to report (default: 0.001).                                                  |
| `--report_id`             | Minimum identity percentage to report alignments (default: 0).                               |
| `--gapopen`               | Gap opening penalty (default: -1; maps to 11 for protein).                                   |
| `--gapextend`             | Gap extension penalty (default: -1; maps to 1 for protein).                                  |
| `-S`, `--seed_len`        | Seed length (default: 15 for DNA, 8 for protein).                                            |
| `--match`                 | Match score (default: 5).                                                                    |
| `--mismatch`              | Mismatch score (default: -4).                                                                |
| `--simd_sort`             | Enable SIMD (AVX2) sorting for double-indexing.                                              |
| `--chimera`               | Enable chimera alignment.                                                                    |
| `--circ`                  | Enable circular alignment.                                                                   |
| `--wga`                   | Enable whole-genome alignment.                                                               |
| `--wgs`                   | Enable whole-genome sequencing.                                                              |
| `--splice`                | Enable splice alignments.                                                                    |
| `--dnah`                  | Enable DNA homology search.                                                                  |
| `--rna`                   | Enable RNA homology search.                                                                  |
| `--avx2`                  | Enable AVX2 hamming distance calculations.                                                   |
| `--hifi`                  | Enable PacBio HiFi/CCS genomic reads.                                                   |
| `--matrix`                | Specify scoring matrix for protein alignment (default: `blosum62`).                          |
| `--SEN`                | Enable sensitive protein alignment.                          |
---

### Advanced Options
| Option                | Description                                                                                |
|-----------------------|--------------------------------------------------------------------------------------------|
| `--xdrop`              | X-drop threshold for ungapped alignment (default: 18).                                      |
| `-X`, `--gapped_xdrop` | X-drop threshold for gapped alignment in bits (default: 18).                                |
| `--ungapped_score`     | Minimum raw alignment score to continue local extension (default: 0).                       |
| `--band`               | Band size for dynamic programming computation (default: 8).                                 |
| `--num_shapes`         | Number of seed shapes to use (default: 0 = all available).                                  |
| `--out2pro`            | Output file for DNA-to-protein conversion (default: `out2pro.fa`).                          |
| `--for_only`           | Enable alignment only on the forward strand.                                                |

---

## Example Usage

### DNA Alignment

1. **Create a nucleotide database**:
    ```bash
    VAT makevatdb --dbtype nucl --in test_all.fa -d mydb
    ```

2. **Run DNA alignment**:
    ```bash
    VAT dna -d mydb.vatf -q test_reads.fa -a alignment_output
    ```

3. **View the results**:
    ```bash
    VAT view -a alignment_output.vatr -f sam/paf/tab -o alignment_output
    vim alignment_output
    ```

---

### Protein Alignment

1. **Create a protein database**:
    ```bash
    VAT makevatdb --dbtype prot --in protein_ref.fa -d protein_db
    ```

2. **Run protein alignment**:
    ```bash
    VAT protein -d protein_db.vatf -q protein_test.fa -a protein_alignment -p 4
    ```

3. **View the results**:
    ```bash
    VAT view -a protein_alignment.vatr -f sam/paf/tab -o protein_alignment
    vim protein_alignment
    ```

---

### BLASTX Alignment

1. **Create a protein database**:
    ```bash
    VAT makevatdb --dbtype prot --in protein_ref.fa -d protein_db
    ```

2. **Run BLASTX alignment**:
    ```bash
    VAT blastx -d protein_db.vatf -q dna_reads.fa -a blastx_output
    ```

3. **View the results**:
    ```bash
    VAT view -a blastx_output.vatr -f sam/paf/tab -o blastx_output
    vim blastx_output
    ```

---

### DNA-to-Protein Conversion

1. **Convert DNA to protein**:
    ```bash
    VAT dna2pro --query dna_sequence.fa --out2pro protein_output.fa
    ```

---

## Troubleshooting

<!-- - **Memory Allocation Issues**:
  Ensure sufficient memory is available when processing large files. Use smaller chunks (`--chunks`) to reduce memory usage. -->
- **Database Type Errors**:
  Specify `--dbtype` as `nucl` or `prot` when creating a database.
- **Alignment Errors**:
  Check input formats (`FASTA`/`FASTQ`) and ensure query and database files are compatible.

---

## Output Formats

| Format | Description                               |
|--------|-------------------------------------------|
| `tab`  | Tab-delimited summary of alignments.      |
| `sam`  | Sequence Alignment/Map format.            |
| `paf`  | Pairwise Alignment Format for long reads. |
| `pairwise` | **BLAST-style pairwise alignment format**, a human-readable output emulating NCBI BLAST, showing alignment scores, identities, and E-values. Ideal for visual inspection of homology alignments. |

Use `-f` to specify the desired output format.

<!-- ---

## Citation

If you use **VATAligner** in your research, please cite: -->

