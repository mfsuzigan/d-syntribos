FROM ubuntu:18.04
MAINTAINER Michel Suzigan <mfsuzigan@gmail.com>
COPY models /home/syntribos/models
COPY payloads /home/syntribos/payloads
COPY d-syntribos.sh /home/syntribos
WORKDIR /home/syntribos
RUN apt-get update && apt-get -y upgrade && apt-get -y install apt-utils python python-pip build-essential python-all-dev python-wheel
RUN python -m pip install --user syntribos
RUN chmod +x d-syntribos.sh
ENTRYPOINT ["./d-syntribos.sh"]
CMD [""]
