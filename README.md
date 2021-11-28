# 2022_shinkei_handson

## 準備

1. sra-tools (fastq files ダウンロード)
2. Trim Galore! (トリミング)
3. salmon (遺伝子発現定量)
4. R (library tximport, tidyverseをインストール)
5. STAR (アラインメントの確認用。定量には使用しない。)
6. samtools (アラインメントの確認用。定量には使用しない。)

## run all scripts

```
bash scripts.sh
```

## ikra

上記の結果はikraを用いて再現できる

```
# install docker
git clone https://github.com/yyoshiaki/ikra.git
ikra/ikra.sh design.csv human --protein-coding --threads 4 --align star --gencode 37
```

## Dockerを用いた環境構築

### Docker HubからPullの場合

```
docker pull yyasumizu/2022shinkeihandson:latest
```

### Buildする場合

```
docker build -t 2022shinkeihandson:latest .
```

### 使用例 (現在のディレクトリをマウント)

1. Docker HubからPullする場合

```
docker run --rm -it -v $PWD:/home --workdir /home yyasumizu/2022shinkeihandson:latest bash
```

2. buildする場合

```
docker run --rm -it -v $PWD:/home --workdir /home 2022shinkeihandson:latest bash
```