#!/usr/bin/env bash
set -euo pipefail

# Benchmark VAT speed (wall time) for:
# - DNA WGS mode
# - Protein alignment
# - blastx (including VAT view conversion)
#
#
# Output:
#   benchmark_out/<timestamp>/results.tsv
#   benchmark_out/<timestamp>/*.time.txt (raw time output per run)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VAT_BIN="${VAT_BIN:-${ROOT_DIR}/bin/VAT}"
THREADS="${THREADS:-4}"
REPEATS="${REPEATS:-1}"

DNA_REF="${DNA_REF:-${ROOT_DIR}/test_case/genome/chr19_GL949746v1_alt.fa}"
DNA_QUERY="${DNA_QUERY:-${ROOT_DIR}/test_case/DNA/test_reads.fq}"
DNA_LONG_QUERY="${DNA_LONG_QUERY:-${ROOT_DIR}/test_case/DNA/2x_long_read.fq.gz}"
DNA_LONG_QUERY_TEST="${DNA_LONG_QUERY_TEST:-${ROOT_DIR}/test_case/DNA/test_long_reads.fq}"
PROT_DB="${PROT_DB:-${ROOT_DIR}/test_case/genome/Pfam_subset.fa}"
PROT_QUERY="${PROT_QUERY:-${ROOT_DIR}/test_case/Protein/pro_test.fa}"

OUT_ROOT="${OUT_ROOT:-${ROOT_DIR}/benchmark_out}"
RUN_ID="${RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)}"
OUT_DIR="${OUT_ROOT}/${RUN_ID}"

mkdir -p "${OUT_DIR}"

if [[ ! -x "${VAT_BIN}" ]]; then
  echo "ERROR: VAT binary not found or not executable: ${VAT_BIN}" >&2
  exit 1
fi

for f in "${DNA_REF}" "${DNA_QUERY}" "${DNA_LONG_QUERY}" "${DNA_LONG_QUERY_TEST}" "${PROT_DB}" "${PROT_QUERY}"; do
  if [[ ! -f "${f}" ]]; then
    echo "ERROR: required input not found: ${f}" >&2
    exit 1
  fi
done

TIME_FMT=$'wall_sec'

RESULTS_TSV="${OUT_DIR}/results.tsv"
echo -e "run_id\tmode\trep\tthreads\tdb\tquery\tout\t${TIME_FMT}" > "${RESULTS_TSV}"

time_run() {
  local mode="$1"; shift
  local rep="$1"; shift
  local db="$1"; shift
  local query="$1"; shift
  local out="$1"; shift
  local label="$1"; shift

  local time_file="${OUT_DIR}/${label}.time.txt"
  # Use bash built-in time to capture wall time in TSV-friendly format.
  # TIMEFORMAT: %R = elapsed wall seconds
  local TIMEFORMAT=$'%R'
  local time_output
  time_output="$( (time "$@") 2>&1 )" || true
  
  # Extract the time metrics (last line from time output)
  local metrics
  metrics="$(echo "${time_output}" | tail -n 1)"
  echo "${metrics}" > "${time_file}"

  echo -e "${RUN_ID}\t${mode}\t${rep}\t${THREADS}\t${db}\t${query}\t${out}\t${metrics}" >> "${RESULTS_TSV}"
}

echo "Benchmark run_id=${RUN_ID}"
echo "  VAT_BIN=${VAT_BIN}"
echo "  THREADS=${THREADS}  REPEATS=${REPEATS}"
echo "  OUT_DIR=${OUT_DIR}"
echo

#############################################
# Build indexes once (if missing)
#############################################

DNA_VATF="${DNA_REF}.vatf"
if [[ ! -f "${DNA_VATF}" ]]; then
  echo "Building DNA VAT DB: ${DNA_REF} -> ${DNA_VATF}"
  TIMEFORMAT=$'%R'
  (time "${VAT_BIN}" makevatdb --in "${DNA_REF}" --dbtype nucl -p "${THREADS}") 2> "${OUT_DIR}/index_dna.time.txt"
fi

PROT_VATF="${PROT_DB}.vatf"
if [[ ! -f "${PROT_VATF}" ]]; then
  echo "Building Protein VAT DB: ${PROT_DB} -> ${PROT_VATF}"
  TIMEFORMAT=$'%R'
  (time "${VAT_BIN}" makevatdb --in "${PROT_DB}" --dbtype prot -p "${THREADS}") 2> "${OUT_DIR}/index_prot.time.txt"
fi

#############################################
# Timed runs
#############################################

for rep in $(seq 1 "${REPEATS}"); do
  # WGS
  wgs_out="${OUT_DIR}/wgs.rep${rep}.sam"
  time_run "wgs" "${rep}" "${DNA_REF}" "${DNA_QUERY}" "${wgs_out}" "wgs_rep${rep}" \
    "${VAT_BIN}" dna -d "${DNA_REF}" -q "${DNA_QUERY}" --wgs -o "${wgs_out}" -f sam -p "${THREADS}"

  # WGS long-read
  wgs_long_out="${OUT_DIR}/wgs_long.rep${rep}.sam"
  time_run "wgs_long" "${rep}" "${DNA_REF}" "${DNA_LONG_QUERY}" "${wgs_long_out}" "wgs_long_rep${rep}" \
    "${VAT_BIN}" dna -d "${DNA_REF}" -q "${DNA_LONG_QUERY}" --wgs --long -o "${wgs_long_out}" -f sam -p "${THREADS}"

  # WGS long-read (test_long_reads.fq)
  wgs_long_test_out="${OUT_DIR}/wgs_long_test.rep${rep}.sam"
  time_run "wgs_long_test" "${rep}" "${DNA_REF}" "${DNA_LONG_QUERY_TEST}" "${wgs_long_test_out}" "wgs_long_test_rep${rep}" \
    "${VAT_BIN}" dna -d "${DNA_REF}" -q "${DNA_LONG_QUERY_TEST}" -o "${wgs_long_test_out}" -f sam -p "${THREADS}"

  # Protein
  prot_out="${OUT_DIR}/protein.rep${rep}.tab"
  time_run "protein" "${rep}" "${PROT_DB}" "${PROT_QUERY}" "${prot_out}" "protein_rep${rep}" \
    "${VAT_BIN}" protein -d "${PROT_DB}" -q "${PROT_QUERY}" -o "${prot_out}" -f tab -p "${THREADS}"

  # blastx (archive + view)
  blastx_prefix="${OUT_DIR}/blastx.rep${rep}"
  blastx_out="${blastx_prefix}.vatr"
  blastx_tab="${blastx_prefix}.tab"

  time_run "blastx" "${rep}" "${PROT_DB}" "${DNA_QUERY}" "${blastx_tab}" "blastx_rep${rep}" \
    "${VAT_BIN}" blastx -d "${PROT_DB}" -q "${DNA_QUERY}" -o "${blastx_tab}" -f tab -p "${THREADS}"

  # time_run "blastx_view" "${rep}" "${PROT_DB}" "${DNA_QUERY}" "${blastx_tab}" "blastx_view_rep${rep}" \
  #   "${VAT_BIN}" view -a "${blastx_out}" -o "${blastx_tab}" -f tab
done

echo
echo "Done."
echo "Results:"
echo "  ${RESULTS_TSV}"

