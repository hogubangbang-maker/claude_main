# scripts/shotgun

| 스크립트 | 하는 일 |
|---|---|
| `run_metaphlan4.sh` | MetaPhlAn 4 샘플별 실행 + 테이블 병합 |
| `run_humann.sh` | HUMAnN 실행 + join / renorm / split |
| `run_kraken2_bracken.sh` | Kraken2 분류 + Bracken 재추정 + 병합 |

실행 전 `scripts/config.example.sh`를 `scripts/config.local.sh`로 복사해 경로를 채우세요.
앞으로 추가할 것: MetaSPAdes, binning, CheckM2, GTDB-Tk, KofamScan, dbCAN, RGI.
