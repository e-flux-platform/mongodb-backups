FROM mongo:5.0.11-focal

RUN apt-get -y update --fix-missing
RUN apt-get -y install curl bash cron

RUN mkdir /workdir
RUN mkdir /workdir/data
WORKDIR /workdir
COPY install_gcloud_sdk.sh /workdir
RUN ./install_gcloud_sdk.sh

ADD . /workdir

CMD ["./entrypoint.sh"]
