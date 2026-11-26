# 🧬 Shotgun Metagenomics 파이프라인

Shotgun 메타게놈 분석의 단계와 순서를 정리합니다. 실제 실행 코드는 [`scripts/shotgun/`](../../scripts/shotgun/)에 있습니다.

## 1. 전처리
| 단계 | 도구 | 입력 → 출력 | 체크 포인트 |
|---|---|---|---|
| QC / trimming | fastp | raw FASTQ → clean FASTQ | Q30 비율, adapter 제거율 |
| Host 제거 | KneadData (Bowtie2) | clean FASTQ → host-free FASTQ | host read 비율 |
| 리포트 | MultiQC | 로그들 → HTML | 샘플 간 편차 |

## 2. Read-based 분석
| 단계 | 도구 | 출력 |
|---|---|---|
| Taxonomy | MetaPhlAn 4 | 샘플별 profile → merged abundance table |
| Taxonomy | Kraken2 + Bracken | report → species-level abundance |
| Function | HUMAnN | genefamilies / pathabundance / pathcoverage |

## 3. Assembly-based 분석
| 단계 | 도구 | 출력 |
|---|---|---|
| Assembly | MetaSPAdes (또는 MEGAHIT) | contigs.fasta |
| Mapping | Bowtie2 + samtools | depth 파일 |
| Binning | MetaBAT2 등 | bins (*.fa) |
| Bin QC | CheckM2 | completeness / contamination |
| Dereplication | dRep | 대표 MAG |
| 분류 | GTDB-Tk | MAG taxonomy |

## 4. 기능 주석
| 대상 | 도구 | 출력 |
|---|---|---|
| Gene 예측 | Prodigal | proteins (.faa) |
| KEGG | KofamScan | KO 할당 |
| CAZyme | dbCAN | CAZy family |
| ARG | RGI (CARD), AMRFinderPlus | 저항성 유전자 |
| VF | VFDB (DIAMOND/BLAST) | 병원성 인자 |

## MAG 품질 기준 (MIMAG)
- **High quality**: completeness > 90%, contamination < 5% (+ rRNA, tRNA 조건)
- **Medium quality**: completeness ≥ 50%, contamination < 10%

## 버전 기록
| 도구 / DB | 버전 | 비고 |
|---|---|---|
| MetaPhlAn DB | | 예: mpa_vJun23 |
| HUMAnN DB | | ChocoPhlAn / UniRef90 |
| Kraken2 DB | | |
| GTDB release | | |
