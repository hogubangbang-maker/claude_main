# 📓 notes

연구 노트를 모으는 곳입니다.

| 폴더 | 용도 |
|---|---|
| `templates/` | 노트 템플릿 (분석 로그, 논문 메모, 에러 기록) |
| `logs/` | 날짜별 분석 로그 `YYYY-MM-DD_주제.md` |

### 빠르게 새 로그 만들기
```bash
cp notes/templates/analysis_log_template.md "notes/logs/$(date +%F)_주제.md"
```
