FROM mongo:5.0.11-focal

RUN apt-get -y update --fix-missing
RUN apt-get -y install curl bash

RUN mkdir /workdir
RUN mkdir /workdir/data
WORKDIR /workdir

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
    && apt-get update -y \
    && apt-get install google-cloud-cli=480.0.0-0 -y

ADD run.sh /workdir
ADD LICENSE /workdir
CMD ["./run.sh"]