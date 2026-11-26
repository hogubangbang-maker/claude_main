<div align="center">

# 🦠 Microbiome Bioinformatics Lab Notebook

**마이크로바이옴 생물정보학(BI) 분석 스크립트와 연구 기록을 모아두는 저장소**

<br/>

![Shotgun](https://img.shields.io/badge/Shotgun-Metagenomics-2E8B57?style=for-the-badge)
![16S/ITS](https://img.shields.io/badge/16S%20%2F%20ITS-Amplicon-4682B4?style=for-the-badge)
![MAG](https://img.shields.io/badge/MAG-Genome%20Resolved-8A2BE2?style=for-the-badge)

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![R](https://img.shields.io/badge/R-276DC3?style=flat-square&logo=r&logoColor=white)
![Conda](https://img.shields.io/badge/Conda-44A833?style=flat-square&logo=anaconda&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)
![Markdown](https://img.shields.io/badge/Notes-Markdown-000000?style=flat-square&logo=markdown&logoColor=white)

</div>

---

## 📌 소개

마이크로바이옴을 공부하는 대학원생의 **분석 파이프라인, 재사용 스크립트, 실험·분석 기록**을 정리하는 공간입니다.

- 🔁 **재현성**: 같은 분석을 나중에 다시 돌릴 수 있도록 명령어, 파라미터, 툴 버전을 남깁니다.
- 🧭 **기록**: 무엇을 왜 했는지, 어떤 결과가 나왔는지 날짜별로 남깁니다.
- 🧰 **재사용**: 자주 쓰는 코드는 템플릿으로 다듬어 `scripts/`에 모읍니다.

> ⚠️ 이 저장소에는 **원시 데이터, 참조 DB, 서버 경로, 개인·환자 정보를 올리지 않습니다.** 자세한 규칙은 [기록 원칙](#-기록-원칙)을 보세요.

---

## 🔬 분석 영역

<table>
<tr>
<td width="50%" valign="top">

### 🧬 Shotgun Metagenomics
- **QC / Host 제거**: fastp, KneadData
- **Taxonomic profiling**: MetaPhlAn 4, Kraken2 + Bracken
- **Functional profiling**: HUMAnN (pathway, gene family)
- **Assembly**: MetaSPAdes / MEGAHIT
- **Binning → MAG**: MetaBAT2 등, CheckM2, dRep
- **MAG 분류**: GTDB-Tk
- **기능 주석**: KofamScan (KEGG KO), dbCAN (CAZyme)
- **저항성·병원성**: ARG (CARD/RGI, AMRFinderPlus), VF (VFDB)

</td>
<td width="50%" valign="top">

### 🧫 Amplicon (16S rRNA / ITS)
- **전처리 & ASV**: QIIME 2 / DADA2
- **분류**: SILVA (16S), UNITE (ITS)
- **기능 예측**: PICRUSt2
- **Biomarker**: LEfSe
- **다양성**: α-diversity, β-diversity (Bray–Curtis, UniFrac)

### 📊 통계 & 시각화 (R)
- phyloseq, vegan, microeco
- ggplot2, ComplexHeatmap
- PERMANOVA, differential abundance (MaAsLin2, ANCOM-BC2)

</td>
</tr>
</table>

---

## 🗺️ 분석 흐름 한눈에 보기

```mermaid
flowchart LR
    A[Raw reads<br/>FASTQ] --> B[QC & Host 제거<br/>fastp / KneadData]

    B --> C[Read-based]
    B --> D[Assembly-based]

    C --> C1[MetaPhlAn 4<br/>Taxonomy]
    C --> C2[Kraken2 + Bracken<br/>Taxonomy]
    C --> C3[HUMAnN<br/>Function]

    D --> D1[MetaSPAdes<br/>Contigs]
    D1 --> D2[Binning<br/>MAGs]
    D2 --> D3[CheckM2 / dRep<br/>품질·중복 제거]
    D3 --> D4[GTDB-Tk<br/>분류]
    D1 --> D5[Gene 예측<br/>Prodigal]
    D5 --> D6[KofamScan · dbCAN<br/>ARG · VF]

    C1 & C2 & C3 & D4 & D6 --> E[R 통계 & 시각화<br/>figures/]

    style A fill:#f9f,stroke:#333
    style E fill:#bbf,stroke:#333
```

```mermaid
flowchart LR
    A2[16S / ITS<br/>FASTQ] --> B2[Primer 제거<br/>cutadapt]
    B2 --> C4[DADA2<br/>ASV table]
    C4 --> D7[분류<br/>SILVA / UNITE]
    D7 --> E1[다양성 분석]
    D7 --> E2[PICRUSt2<br/>기능 예측]
    D7 --> E3[LEfSe<br/>Biomarker]
    E1 & E2 & E3 --> F2[R 시각화]
```

---

## 🧰 툴 스택

| 단계 | 도구 | 비고 |
|---|---|---|
| QC | `fastp`, `FastQC`, `MultiQC` | 리포트는 요약만 기록 |
| Host 제거 | `KneadData`, `Bowtie2` | |
| Taxonomy (read) | `MetaPhlAn 4`, `Kraken2`, `Bracken` | DB 버전 꼭 기록 |
| Function (read) | `HUMAnN` | ChocoPhlAn / UniRef90 |
| Assembly | `MetaSPAdes`, `MEGAHIT` | |
| Binning / QC | `MetaBAT2`, `CheckM2`, `dRep` | |
| MAG taxonomy | `GTDB-Tk` | GTDB release 기록 |
| 기능 주석 | `Prodigal`, `KofamScan`, `dbCAN` | KEGG KO, CAZyme |
| ARG / VF | `RGI (CARD)`, `AMRFinderPlus`, `VFDB` | |
| Amplicon | `QIIME 2`, `DADA2`, `cutadapt` | |
| 기능 예측 | `PICRUSt2` | |
| Biomarker | `LEfSe`, `MaAsLin2`, `ANCOM-BC2` | |
| 통계·시각화 | `R`: phyloseq, vegan, ggplot2 | |

툴 설치 환경 예시는 [`envs/`](envs/)에, 짧은 사용법 메모는 [`docs/cheatsheet.md`](docs/cheatsheet.md)에 있습니다.

---

## 📁 폴더 구조

```text
claude_main/
├── README.md               ← 지금 보고 있는 문서
├── pipelines/              ← 단계별 분석 흐름 설명 (무엇을 어떤 순서로)
│   ├── shotgun/
│   └── amplicon/
├── scripts/                ← 실제로 돌리는 재사용 코드
│   ├── shotgun/            ← MetaPhlAn, HUMAnN, Kraken2 ... 실행 템플릿
│   ├── amplicon/           ← DADA2, PICRUSt2, LEfSe ...
│   ├── R/                  ← 통계 & 피겨 스크립트
│   └── utils/              ← 테이블 병합·변환 같은 소도구
├── notes/                  ← 분석 기록 (연구 노트)
│   ├── templates/          ← 노트 템플릿
│   └── logs/               ← 날짜별 분석 로그 (YYYY-MM-DD_주제.md)
├── figures/                ← 최종 피겨 (PNG/PDF, 작은 용량만)
├── envs/                   ← conda 환경 파일
└── docs/                   ← 툴 치트시트, 참고 자료
```

---

## 📝 기록 원칙

1. **날짜별 로그**: 분석할 때마다 `notes/logs/YYYY-MM-DD_주제.md`를 만들고 [분석 노트 템플릿](notes/templates/analysis_log_template.md)을 복사해서 씁니다.
2. **명령어 + 버전**: 실행한 명령어, 툴·DB 버전을 그대로 붙여 넣습니다.
3. **경로는 변수로**: 스크립트 안의 서버 경로는 `${DB_DIR}`, `${OUT_DIR}`처럼 변수로 두고 실제 값은 올리지 않습니다 (`*.local.*` 파일은 `.gitignore`에 포함).
4. **데이터는 밖에**: FASTQ, BAM, DB, 어셈블리 결과는 커밋하지 않습니다. 작은 요약 테이블과 피겨만 올립니다.
5. **커밋 메시지**: `[영역] 내용` 형식을 씁니다.
   - `[shotgun] HUMAnN 실행 스크립트 추가`
   - `[R] β-diversity PCoA 피겨 스크립트`
   - `[notes] 2026-11-26 MAG binning 결과 기록`

---

## 📚 공부 기록

| 날짜 | 주제 | 기록 |
|---|---|---|
| 2026-11-26 | 저장소 시작 🎉 | [notes/logs/2026-11-26_repo-setup.md](notes/logs/2026-11-26_repo-setup.md) |
| | | |

---

<div align="center">

*Sequencing reads → biological insight, one commit at a time.* 🧪

</div>
