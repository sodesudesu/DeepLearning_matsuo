# 深層学習の課題のメモ

一応記録。
[松尾研の教材](https://github.com/matsuolab-edu/dl4us/blob/master/)の更新が止まっているので、特にライブラリのインストールで色々失敗しました。
紆余曲折あってDockerでPythonを使うことにしました。
Dockerイメージはここで公開します。

以下、Dockerイメージの説明です。
（これをご覧になれば明らかなように、僕のPython & Docker経験値は低い。）

## 動作確認をした環境

- M2 Macbook Air
- WSL2(Ubuntu)

## Dockerイメージのビルド

### ファイルの説明

Dokerfileの中身は以下の通りです：
```
FROM python:3.11.8
WORKDIR /work
COPY requirements.txt ./

RUN apt-get update && apt-get install -y \
    graphviz
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt
EXPOSE 8888
```

はじめ、Macbook本体に入れていた[本家のpython](https://www.python.org/downloads/)のバージョン3.12でTensorflowを使おうとしたらトラブルがあったので、ここではpython3.11.8を指定しました。

[requirements.txt](./requirements.txt)に含めたパッケージは[松尾研が公開しているもの](https://github.com/matsuolab-edu/dl4us/blob/master/requirements.txt)よりも少なくしました。
最低限、Lesson1を実行できるはずです。
バージョンも2024年2月25日時点のpipでインストールできるように変更しました。
requirements.txtの中身は次の通りです：
```
Keras==2.15.0
matplotlib==3.5.1
numpy==1.26.2
opencv-python==4.9.0.80
pandas==1.4.1
pydot==1.4.2
pydotplus==2.0.2
requests==2.26.0
scikit-learn==1.4.0
tensorflow==2.15.0
graphviz==0.20.1
jupyter==1.0.0
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

Dockerfileのあるディレクトリで
```
docker image build -t mypython:3.11.8 . 
```
によってビルドできます。

## 実行

お好きなディレクトリで
```
docker container run -it --rm -p 8888:8888 --mount type=bind,src=$(pwd),dst=/work mypython:3.11.8 bash
```
と書けば、コンテナが起動しシェルの画面になります。

Jupyter Notebookが使いたければ、
```
jupyter notebook --ip=0.0.0.0 --allow-root --port=8888 &
```
と命令すれば良いです。
ブラウザが勝手に立ち上がるものだと思っていたが反応がないので、jupyterの起動時に教えてくれるURLとトークンをブラウザで入力しなければダメでした。
