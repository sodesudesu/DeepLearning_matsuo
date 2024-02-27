# buildはdocker image build -t mypython:3.11.8 .
# コンテナ起動はdocker-compose up
# opencvとmakeupsafeはバージョンを書き換えた

FROM python:3.11.8
WORKDIR /work
COPY requirements.txt ./

RUN apt-get update && apt-get install -y \
    graphviz
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt
EXPOSE 8888
