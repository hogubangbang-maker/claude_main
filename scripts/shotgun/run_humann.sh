#!/usr/bin/env bash
# ============================================================
#  HUMAnN: 기능 프로파일링 (gene family / pathway)
#  HUMAnN 은 paired-end 를 따로 받지 않으므로 R1+R2 를 이어붙여 넣습니다.
#  출력: ${OUT_DIR}/humann/ 아래 *_genefamilies / *_pathabundance / *_pathcoverage
# ============================================================
set -euo pipefail
source "$(dirname "$0")/../config.local.sh"

OUT="${OUT_DIR}/humann"
CAT_DIR="${OUT}/concat"
mkdir -p "${OUT}" "${CAT_DIR}"

for R1 in "${CLEAN_DIR}"/*_R1.fastq.gz; do
    SAMPLE=$(basename "${R1}" _R1.fastq.gz)
    R2="${CLEAN_DIR}/${SAMPLE}_R2.fastq.gz"
    CAT="${CAT_DIR}/${SAMPLE}.fastq.gz"
    cat "${R1}" "${R2}" > "${CAT}"

    echo "[$(date '+%F %T')] HUMAnN: ${SAMPLE}"
    humann --input "${CAT}" \
        --output "${OUT}/${SAMPLE}" \
        --nucleotide-database "${HUMANN_NUC_DB}" \
        --protein-database "${HUMANN_PROT_DB}" \
        --threads "${THREADS}"
    rm -f "${CAT}"   # 용량 절약
done

# 테이블 병합 → 정규화(relab) → stratified/unstratified 분리
mkdir -p "${OUT}/merged"
for T in genefamilies pathabundance pathcoverage; do
    humann_join_tables -i "${OUT}" -o "${OUT}/merged/${T}.tsv" --file_name "${T}" --search-subdirectories
done
humann_renorm_table -i "${OUT}/merged/pathabundance.tsv" -o "${OUT}/merged/pathabundance_relab.tsv" -u relab
humann_split_stratified_table -i "${OUT}/merged/pathabundance_relab.tsv" -o "${OUT}/merged"
