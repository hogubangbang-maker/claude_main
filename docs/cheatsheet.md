# 🧾 툴 치트시트

자주 쓰는 명령어를 짧게 모았습니다. 경로는 모두 변수로 둡니다.

## QC
```bash
fastp -i R1.fq.gz -I R2.fq.gz -o clean_R1.fq.gz -O clean_R2.fq.gz \
      -w ${THREADS} -h sample.fastp.html -j sample.fastp.json
multiqc . -o multiqc_report
```

## MetaPhlAn 4
```bash
metaphlan R1.fq.gz,R2.fq.gz --input_type fastq --nproc ${THREADS} \
          --mapout sample.mapout.bz2 -o sample_profile.txt
merge_metaphlan_tables.py *_profile.txt > merged_abundance.txt
```

## HUMAnN
```bash
humann --input sample.fq.gz --output humann_out --threads ${THREADS}
humann_join_tables -i humann_out -o pathabundance.tsv --file_name pathabundance
humann_renorm_table -i pathabundance.tsv -o pathabundance_relab.tsv -u relab
```

## Kraken2 + Bracken
```bash
kraken2 --db ${KRAKEN2_DB} --paired --threads ${THREADS} --report s.k2report R1 R2 > /dev/null
bracken -d ${KRAKEN2_DB} -i s.k2report -o s.bracken -r 150 -l S
```

## Assembly → MAG
```bash
metaspades.py -1 R1.fq.gz -2 R2.fq.gz -o spades_out -t ${THREADS}
bowtie2-build contigs.fasta contigs && bowtie2 -x contigs -1 R1 -2 R2 -p ${THREADS} | samtools sort -o s.bam
jgi_summarize_bam_contig_depths --outputDepth depth.txt *.bam
metabat2 -i contigs.fasta -a depth.txt -o bins/bin
checkm2 predict -i bins -x fa -o checkm2_out -t ${THREADS}
gtdbtk classify_wf --genome_dir bins -x fa --out_dir gtdbtk_out --cpus ${THREADS}
```

## 기능 주석
```bash
prodigal -i contigs.fasta -a proteins.faa -p meta
exec_annotation -o kofam.txt --profile ${KOFAM_PROFILES} --ko-list ${KO_LIST} \
                --cpu ${THREADS} -f mapper proteins.faa
rgi main -i proteins.faa -t protein -o rgi_out -n ${THREADS}
```

## Amplicon
```bash
cutadapt -g ${FWD} -G ${REV} -o out_R1.fq.gz -p out_R2.fq.gz in_R1.fq.gz in_R2.fq.gz
picrust2_pipeline.py -s asv.fna -i asv_table.biom -o picrust2_out -p ${THREADS}
lefse_format_input.py lefse_in.txt lefse.in -c 1 -u 2 -o 1000000
lefse_run.py lefse.in lefse.res -l 2.0
```

## 자주 보는 기준값
| 항목 | 기준 |
|---|---|
| MAG high quality | completeness > 90%, contamination < 5% |
| MAG medium quality | completeness ≥ 50%, contamination < 10% |
| LEfSe | LDA score > 2.0 |
| PICRUSt2 NSTI | 보통 2 이상인 ASV는 제외 |
