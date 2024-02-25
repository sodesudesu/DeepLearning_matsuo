# 深層学習の課題のメモ

一応記録。
[松尾研の教材](https://github.com/matsuolab-edu/dl4us/blob/master/)の更新が止まっているので、特にパッケージのインストールで色々失敗しています。
紆余曲折あってDockerでPythonを使うことにしました。

## 動作確認をした環境

- M2 Macbook Air
- WSL2(Ubuntu)

## dockerイメージのビルド

### ファイルの説明

Dokerfileの中身は以下の通りです：
```
FROM python:3.11.8
WORKDIR /work
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt
EXPOSE 8888
```

はじめ、Macbook本体に入れていた[本家のpython](https://www.python.org/downloads/)のバージョン3.12でTensorflowを使おうとしたらトラブルがあったので、このイメージではpython3.11.8を指定しました。

[requirements.txt](./requests.txt)で指定したパッケージは[松尾研が公開しているもの](https://github.com/matsuolab-edu/dl4us/blob/master/requirements.txt)よりも少なくしました。
バージョンも今日のpipでインストールできるように変更しました（ただし作業日は2024年2月25日）。
requirements.txtの中身は次の通りです：
```
Keras==2.15.0
scikit-learn==1.4.0
tensorflow==2.15.0
numpy==1.26.2
pydotplus==2.0.2
matplotlib==3.5.1
pandas==1.4.1
requests==2.26.0
jupyter==1.0.0
opencv-python==4.9.0.80
pydot==1.4.2
```

<!--
[docker-compose.yml](./docker-compose.yml)も作りました：
```
version: '3'
services:
  mypython:
    image: mypython:3.11.8
    ports:
      - "8888:8888"
    volumes:
      - ${PWD}:/work
    stdin_open: true
    tty: true
    restart: unless-stopped
```
-->

### ビルド

Dockerfileのあるディレクトリで（ここではdl4usディレクトリにDockerfileを配置しています）
```
docker image build -t mypython:3.11.8 . 
```
によってビルドできます。

## 実行

### コンテナの起動

dl4usディレクトリで
```
docker container run -it --rm -p 8888:8888 --mount type=bind,src=$(pwd),dst=/work mypython:3.11.8 bash
```
と書けば、コンテナが起動しシェルの画面になります。
