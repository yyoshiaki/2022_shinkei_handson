# 日本神経学会主催 産官学教育研修会 「脳神経内科医のためのバイオインフォマティクス・ハンズオン 2021」 

## 準備

### Dockerを用いない場合

1. sra-tools (fastq files ダウンロード)
2. Trim Galore! (トリミング)
3. salmon (遺伝子発現定量)
4. R (library tximport, tidyverseをインストール)
5. STAR (アラインメントの確認用。定量には使用しない。)
6. samtools (アラインメントの確認用。定量には使用しない。)

### Dockerを用いる場合

[公式サイト](https://docs.docker.jp/desktop/index.html)を参照の上、Dockerをインストールしてください。

## clone

```
git clone https://github.com/yyoshiaki/2022_shinkei_handson.git
```

## run all scripts

```
bash scripts.sh
```

## ikra

上記の結果は[ikra](https://github.com/yyoshiaki/ikra)を用いて再現できる

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
docker build -t 2022shinkeihandson:latest .
docker run --rm -it -v $PWD:/home --workdir /home 2022shinkeihandson:latest bash
```

### Permission Errorが出る場合（主にlinuxを使用する場合）

ローカルからディレクトリのパーミッションを777に変更した後にdockerを起動

```
chmod 777 .
docker run --rm -it -v $PWD:/home --workdir /home yyasumizu/2022shinkeihandson:latest bash
```

## 下流解析

[iDEP](http://bioinformatics.sdstate.edu/idep94/)を紹介します。


## Q&A

1. anacondaがインストールできない : macOSをアップデート。10.13以降必須。もしくはM1 Macの場合dockerを使用する。
2. fasterq-dumpが動かない場合 : `vdb-config -i` は実行済みか確認。
3. WSLがうまく動かない : [公式サイト](https://docs.microsoft.com/ja-jp/windows/wsl/install)をよくご確認ください。特に、OSが前提条件を満たしているかなど慎重にご確認ください。

## おすすめの参考書籍

1. [RNA-Seqデータ解析　WETラボのための鉄板レシピ](https://www.yodosha.co.jp/yodobook/book/9784758122436/)
2. [次世代シークエンサーDRY解析教本　改訂第2版](https://gakken-mesh.jp/book/detail/9784780909838.html)