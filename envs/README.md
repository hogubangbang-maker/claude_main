# envs

| 파일 | 용도 |
|---|---|
| `shotgun.yml` | QC, read-based profiling, assembly |
| `annotation.yml` | MAG QC·분류, 기능·ARG 주석 |
| `amplicon.yml` | cutadapt, PICRUSt2, LEfSe |

HUMAnN, dbCAN, QIIME 2는 공식 설치 방법을 따르는 편이 안전해서 따로 설치합니다.
설치 후 `conda env export --no-builds > envs/<이름>.lock.yml`로 실제 버전을 남기세요.
