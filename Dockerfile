FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y --no-install-recommends --allow-unauthenticated install \
   build-essential \
   git \
   zip \
   unzip \
   xz-utils \
   wget \
   curl \
   ca-certificates \
   make \
   bash \
   bc \
   file

# RUN adduser --disabled-password --gecos "" --uid 1001 runner \
#     && groupadd docker --gid 123 \
#     && usermod -aG sudo runner \
#     && usermod -aG docker runner \

# RUN addgroup --g 1000 groupcontainer
# RUN adduser -u 1000 -G groupcontainer -h /home/containeruser -D containeruser

# USER containeruser
# RUN apt-get install -y \
#    gcc-arm-none-eabi \
#    gcc-arm-linux-gnueabihf=4:10.2.1-1

RUN apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
   ln -f -s /usr/aarch64-linux-gnu/lib/ld-linux-aarch64.so.1 /lib && \
   ln -f -s /usr/aarch64-linux-gnu/lib/libc.so.6 /lib && \
   ln -f -s /usr/aarch64-linux-gnu/lib/libdl.so.2 /lib && \
   ln -f -s /usr/aarch64-linux-gnu/lib/libm.so.6 /lib
   
RUN cd /opt; \
   wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-aarch64-arm-none-linux-gnueabihf.tar.xz; \
   tar xvfJ gcc-arm-10.3-2021.07-aarch64-arm-none-linux-gnueabihf.tar.xz; \
   rm gcc-arm-10.3-2021.07-aarch64-arm-none-linux-gnueabihf.tar.xz

RUN mkdir /workspace
COPY . /workspace

WORKDIR /workspace
VOLUME /workspace

CMD ls -la && \
   ./makeimage.sh
