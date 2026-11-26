#!/usr/bin/env bash
# ============================================================
#  Kraken2 + Bracken: species-level abundance 추정
#  READ_LEN 은 시퀀싱 read 길이 (Bracken DB 를 만든 길이와 같아야 함)
# ============================================================
set -euo pipefail
source "$(dirname "$0")/../config.local.sh"

READ_LEN=150
LEVEL=S          # S=species, G=genus
OUT="${OUT_DIR}/kraken2"
mkdir -p "${OUT}"

for R1 in "${CLEAN_DIR}"/*_R1.fastq.gz; do
    SAMPLE=$(basename "${R1}" _R1.fastq.gz)
    R2="${CLEAN_DIR}/${SAMPLE}_R2.fastq.gz"

    echo "[$(date '+%F %T')] Kraken2: ${SAMPLE}"
    kraken2 --db "${KRAKEN2_DB}" \
        --threads "${THREADS}" \
        --paired --gzip-compressed \
        --report "${OUT}/${SAMPLE}.k2report" \
        --output /dev/null \
        "${R1}" "${R2}"

    bracken -d "${KRAKEN2_DB}" \
        -i "${OUT}/${SAMPLE}.k2report" \
        -o "${OUT}/${SAMPLE}.bracken" \
        -r "${READ_LEN}" -l "${LEVEL}"
done

combine_bracken_outputs.py --files "${OUT}"/*.bracken -o "${OUT}/merged_bracken_${LEVEL}.tsv"
