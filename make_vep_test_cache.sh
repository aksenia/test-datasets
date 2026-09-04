#!/usr/bin/env bash
# Generate a minimal VEP test cache from the full Ensembl indexed VEP cache.
#
# Output structure matches committed reference/vep_cache_test_data.tar.gz:
#   vep_cache_test_data/<version>_GRCh38/<chrom>/<chunk>.gz
# (no homo_sapiens/ prefix — nallo's VEP module handles species dir mapping)
#
# Test regions:
#   chr16 : 160000-177522       -> chunk 1-1000000
#   chr17 : 3053138-3073138     -> chunk 3000001-4000000
#   chr20 : 2652400-2653100     -> chunk 2000001-3000000  [addition vs original]
#   chrX  : somalier sites      -> chunk 140000001-141000000
#   chrM  : full                -> chunk 1-1000000 + all_vars
#
# Note: _var.gz per-chunk files (in original) are not present in the indexed cache.
# MT/all_vars.gz is kept as it was in the original.
# chr16/chrX all_vars.gz not included - original didn't have them, too large for git.
#
# Usage:
#   bash make_vep_test_cache.sh <cache.tar.gz> <workdir> <version>
# Example (v110):
#   bash make_vep_test_cache.sh homo_sapiens_vep_110_GRCh38.tar.gz work 110
# Example (v116):
#   bash make_vep_test_cache.sh homo_sapiens_vep_116_GRCh38.tar.gz work16 116

set -euo pipefail

CACHE_TARBALL="${1:?Usage: $0 <cache.tar.gz> <workdir> <version>}"
WORK_DIR="${2:?}"
VERSION="${3:?}"

SPECIES="homo_sapiens"
STAGE_DIR="${WORK_DIR}/vep_cache_test_data/${VERSION}_GRCh38"
TEMP_DIR="${WORK_DIR}/tmp_extract_$$"
OUT_TARBALL="${WORK_DIR}/vep_cache_test_data.tar.gz"

echo "==> Cache tarball : ${CACHE_TARBALL}"
echo "==> Stage dir     : ${STAGE_DIR}"
echo "==> Output        : ${OUT_TARBALL}"

mkdir -p "${STAGE_DIR}" "${TEMP_DIR}"

SRC_FILES=(
    "${SPECIES}/${VERSION}_GRCh38/16/1-1000000.gz"
    "${SPECIES}/${VERSION}_GRCh38/16/1-1000000_reg.gz"
    "${SPECIES}/${VERSION}_GRCh38/17/3000001-4000000.gz"
    "${SPECIES}/${VERSION}_GRCh38/17/3000001-4000000_reg.gz"
    "${SPECIES}/${VERSION}_GRCh38/20/2000001-3000000.gz"
    "${SPECIES}/${VERSION}_GRCh38/20/2000001-3000000_reg.gz"
    "${SPECIES}/${VERSION}_GRCh38/MT/1-1000000.gz"
    "${SPECIES}/${VERSION}_GRCh38/MT/1-1000000_reg.gz"
    "${SPECIES}/${VERSION}_GRCh38/MT/all_vars.gz"
    "${SPECIES}/${VERSION}_GRCh38/MT/all_vars.gz.csi"
    "${SPECIES}/${VERSION}_GRCh38/X/140000001-141000000.gz"
    "${SPECIES}/${VERSION}_GRCh38/X/140000001-141000000_reg.gz"
    "${SPECIES}/${VERSION}_GRCh38/info.txt"
    "${SPECIES}/${VERSION}_GRCh38/chr_synonyms.txt"
)

echo "==> Extracting (single pass over ${CACHE_TARBALL})..."
tar xzf "${CACHE_TARBALL}" -C "${TEMP_DIR}" "${SRC_FILES[@]}" 2>&1 | grep -v 'X11 forwarding' || true

echo ""
echo "==> Checking and staging files..."
MISSING=0
for f in "${SRC_FILES[@]}"; do
    src="${TEMP_DIR}/${f}"
    base="${f#${SPECIES}/${VERSION}_GRCh38/}"
    dst="${STAGE_DIR}/${base}"
    mkdir -p "$(dirname "${dst}")"
    if [[ -f "${src}" && -s "${src}" ]]; then
        cp "${src}" "${dst}"
        echo "  OK      ${base}  ($(du -h "${src}" | cut -f1))"
    else
        echo "  MISSING ${base}"
        MISSING=$((MISSING + 1))
    fi
done

rm -rf "${TEMP_DIR}"

echo ""
if [[ ${MISSING} -gt 0 ]]; then
    echo "ERROR: ${MISSING} required files missing. Cannot build test cache." >&2
    exit 1
fi

echo "==> Staged contents:"
find "${STAGE_DIR}" -type f | sort

echo ""
echo "==> Packing ${OUT_TARBALL}..."
tar czf "${OUT_TARBALL}" -C "${WORK_DIR}" vep_cache_test_data/
echo "==> Done: $(du -h "${OUT_TARBALL}" | cut -f1)"
echo ""
echo "==> Structure:"
tar tzf "${OUT_TARBALL}" | sort
echo ""
echo "Next steps:"
echo "  1. Commit to test-datasets PR branch and push"
echo "  2. Update pipelines_testdata_base_path SHA in nallo/tests/nextflow.config"
