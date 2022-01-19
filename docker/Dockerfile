ARG HTTP_PROXY=
ARG HTTPS_PROXY=
ARG NO_PROXY=

FROM ubuntu:20.04

ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY
ENV NO_PROXY=$NO_PROXY

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata

RUN apt install -y sudo
RUN echo '%sudo ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN echo 'Set disable_coredump false' >> /etc/sudo.conf

RUN echo y | sudo unminimize

COPY var/public/env.sh /opt/mydocker3/public/
COPY var/public/lib/common/sudowr.sh /opt/mydocker3/public/lib/common/

COPY var/public/packages/apt1.sh /opt/mydocker3/public/packages/
RUN MYDOCKER3_PATH=/opt/mydocker3 bash /opt/mydocker3/public/packages/apt1.sh

COPY var/public/packages/awscli.sh /opt/mydocker3/public/packages/
RUN MYDOCKER3_PATH=/opt/mydocker3 bash /opt/mydocker3/public/packages/awscli.sh

COPY var/public/packages/apt2.sh /opt/mydocker3/public/packages/
RUN MYDOCKER3_PATH=/opt/mydocker3 bash /opt/mydocker3/public/packages/apt2.sh

COPY var/public/packages/python.sh /opt/mydocker3/public/packages/
RUN MYDOCKER3_PATH=/opt/mydocker3 bash /opt/mydocker3/public/packages/python.sh

COPY var/public/packages/nodejs.sh /opt/mydocker3/public/packages/
RUN MYDOCKER3_PATH=/opt/mydocker3 bash /opt/mydocker3/public/packages/nodejs.sh

COPY entrypoint-root.sh /opt/mydocker3/public/docker/entrypoint-root.sh
COPY entrypoint-user.sh /opt/mydocker3/public/docker/entrypoint-user.sh
CMD ["bash", "/opt/mydocker3/public/docker/entrypoint-root.sh"]
