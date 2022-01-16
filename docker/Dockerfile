FROM ubuntu:20.04

RUN apt update && apt upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata

RUN apt install -y sudo
RUN echo '%sudo ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN echo 'Set disable_coredump false' >> /etc/sudo.conf

RUN apt install -y git
#RUN apt install -y ncat
#RUN apt install -y openssh-server
#RUN service ssh start
#RUN useradd -m -u 9801 --groups sudo mydocker

RUN mkdir -p /opt/mydocker3
#RUN git clone https://github.com/suzuki-navi/mydocker3-public.git /opt/mydocker3/public
COPY var/public /opt/mydocker3/public
RUN MYDOCKER3_PATH=/opt/mydocker3 bash /opt/mydocker3/public/sync-packages.sh

COPY entrypoint.sh /opt/mydocker3/public/docker/entrypoint.sh
COPY entrypoint2.sh /opt/mydocker3/public/docker/entrypoint2.sh
CMD ["bash", "/opt/mydocker3/public/docker/entrypoint.sh"]
