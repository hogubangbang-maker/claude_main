# 🧫 Amplicon (16S / ITS) 파이프라인

16S rRNA와 ITS 앰플리콘 분석 흐름입니다. 실행 코드는 [`scripts/amplicon/`](../../scripts/amplicon/)에 있습니다.

## 단계
| # | 단계 | 도구 | 메모 |
|---|---|---|---|
| 1 | Primer 제거 | cutadapt | 16S V3–V4 / ITS1·ITS2 primer 기록 |
| 2 | Denoising | DADA2 (R 또는 QIIME 2) | truncLen, maxEE 기록 |
| 3 | Chimera 제거 | DADA2 `removeBimeraDenovo` | |
| 4 | 분류 | SILVA (16S) / UNITE (ITS) | DB 버전 기록 |
| 5 | 필터링 | 미토콘드리아·엽록체 제거, rarefaction 여부 | |
| 6 | 다양성 | phyloseq, vegan | Shannon, Observed / Bray–Curtis, UniFrac |
| 7 | 기능 예측 | PICRUSt2 | NSTI 값 확인 |
| 8 | Biomarker | LEfSe | LDA cutoff (보통 2.0) |

## 16S vs ITS 차이 메모
- ITS는 길이 변이가 커서 **truncLen을 고정하지 않는 편**이 일반적입니다.
- ITS는 PICRUSt2 기능 예측의 근거가 약하므로 해석에 주의합니다.

## 파라미터 기록
| 항목 | 16S | ITS |
|---|---|---|
| Primer (F/R) | | |
| truncLen (F/R) | | — |
| maxEE | | |
| 분류 DB | SILVA | UNITE |
