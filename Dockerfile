FROM ubuntu:16.04
MAINTAINER Michel Suzigan <mfsuzigan@gmail.com
WORKDIR /home/syntribos
USER root
COPY syntribos /home/syntribos
COPY poi /home/syntribos/poi
RUN apt-get update && apt-get -y upgrade && apt-get -y install git python python-pip && pip install --upgrade pip
RUN pip install .
RUN syntribos init --no_downloads --force
ENTRYPOINT ["syntribos"]
CMD [""]
