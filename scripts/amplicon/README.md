# scripts/amplicon

16S / ITS 분석 스크립트를 둘 자리입니다.

| 예정 스크립트 | 하는 일 |
|---|---|
| `dada2_16S.R` | filterAndTrim → learnErrors → dada → mergePairs → chimera 제거 → SILVA 분류 |
| `dada2_ITS.R` | cutadapt 후 truncLen 없이 DADA2, UNITE 분류 |
| `run_picrust2.sh` | `picrust2_pipeline.py` 실행 + 경로 기록 |
| `run_lefse.sh` | `lefse_format_input.py` → `lefse_run.py` → 플롯 |

순서는 [`pipelines/amplicon`](../../pipelines/amplicon/README.md)을 참고하세요.
