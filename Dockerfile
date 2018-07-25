FROM ubuntu:16.04
MAINTAINER hao <exiaohao@gmail.com>

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install python python-dev python-pip python-m2crypto curl wget unzip gcc swig automake make perl cpio build-essential git ntpdate

COPY ./libsodium-1.0.12.tar.gz /opt
COPY ./shadowsocksr-1.zip /opt
COPY ./ssr /etc/init.d/ssr

WORKDIR /opt
RUN tar zfvx libsodium-1.0.12.tar.gz
WORKDIR /opt/libsodium-1.0.12
RUN ./configure
RUN make && make install

RUN echo "include ld.so.conf.d/*.conf" > /etc/ld.so.conf
RUN echo "/lib" >> /etc/ld.so.conf
RUN echo "/usr/lib64" >> /etc/ld.so.conf
RUN echo "/usr/local/lib" >> /etc/ld.so.conf
RUN ldconfig
RUN rm -rf /opt/libsodium-1.0.12

WORKDIR /
COPY ./shadowsocksr /ssr

CMD python ssr/shadowsocks/server.py -p $LISTEN_PORT -k $PASSWORD -m $ENCRYPT_METHOD -o $OBFS_METHOD -t $TIMEOUT --fast-open