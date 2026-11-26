#!/usr/bin/env bash
# ============================================================
#  경로 설정 예시 파일
#  사용법: 이 파일을 config.local.sh 로 복사해서 실제 경로를 넣으세요.
#          config.local.sh 는 .gitignore 에 걸려 있어 커밋되지 않습니다.
#    cp scripts/config.example.sh scripts/config.local.sh
# ============================================================

export PROJECT_DIR="/path/to/project"        # 분석 작업 폴더
export RAW_DIR="${PROJECT_DIR}/data/raw"     # 원시 FASTQ
export CLEAN_DIR="${PROJECT_DIR}/data/clean" # QC/host 제거 후 FASTQ
export OUT_DIR="${PROJECT_DIR}/results"      # 결과 출력

# 참조 데이터베이스
export METAPHLAN_DB="/path/to/metaphlan_db"
export HUMANN_NUC_DB="/path/to/humann/chocophlan"
export HUMANN_PROT_DB="/path/to/humann/uniref"
export KRAKEN2_DB="/path/to/kraken2_db"
export GTDBTK_DATA_PATH="/path/to/gtdbtk_data"

export THREADS=16
