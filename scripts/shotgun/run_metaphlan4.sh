#!/usr/bin/env bash
# ============================================================
#  MetaPhlAn 4: 샘플별 taxonomic profiling → 테이블 병합
#  입력: ${CLEAN_DIR}/<sample>_R1.fastq.gz, _R2.fastq.gz
#  출력: ${OUT_DIR}/metaphlan/<sample>_profile.txt, merged_abundance.txt
#  주의: MetaPhlAn 4.1 부터 --bowtie2out 대신 --mapout 을 씁니다. 버전을 확인하세요.
# ============================================================
set -euo pipefail
source "$(dirname "$0")/../config.local.sh"

OUT="${OUT_DIR}/metaphlan"
mkdir -p "${OUT}"

for R1 in "${CLEAN_DIR}"/*_R1.fastq.gz; do
    SAMPLE=$(basename "${R1}" _R1.fastq.gz)
    R2="${CLEAN_DIR}/${SAMPLE}_R2.fastq.gz"
    [[ -s "${OUT}/${SAMPLE}_profile.txt" ]] && { echo "skip ${SAMPLE}"; continue; }

    echo "[$(date '+%F %T')] MetaPhlAn: ${SAMPLE}"
    metaphlan "${R1},${R2}" \
        --input_type fastq \
        --db_dir "${METAPHLAN_DB}" \
        --mapout "${OUT}/${SAMPLE}.mapout.bz2" \
        --nproc "${THREADS}" \
        -o "${OUT}/${SAMPLE}_profile.txt"
done

merge_metaphlan_tables.py "${OUT}"/*_profile.txt > "${OUT}/merged_abundance.txt"
metaphlan --version > "${OUT}/VERSION.txt" 2>&1
echo "done → ${OUT}/merged_abundance.txt"
