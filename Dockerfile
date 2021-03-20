FROM alpine:latest as builder

# Source download dependencies
RUN apk add --update git bash

# Download sources
RUN \
  git clone https://github.com/p4lang/behavioral-model.git && \
  git clone https://github.com/p4lang/PI.git && \
  git clone https://github.com/p4lang/p4c && \
  (cd PI && git submodule update --init --recursive) && \
  (cd p4c && git submodule update --init --recursive)

RUN wget https://sourceforge.net/projects/judy/files/judy/Judy-1.0.5/Judy-1.0.5.tar.gz

# Install libJudy
RUN apk add --update gcc make musl-dev

RUN tar -xvf Judy-1.0.5.tar.gz && \
  (cd judy-*/ && \
    ./configure && \
    make && \
    make install \
  )

# Install PI
RUN apk add --update automake autoconf pkgconf gcc g++ make \
  flex bison libtool boost-dev protobuf-c-dev protobuf-dev grpc grpc-dev \
  c-ares-dev

RUN \
  (cd PI && \
    ./autogen.sh && \
    ./configure --with-proto && \
    make -j$(nproc) && \
    make install \
  )

# Install behavioral-model
RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/testing --update \
  thrift thrift-dev
RUN apk add --update automake autoconf pkgconf gcc g++ make \
  flex bison libtool gmp-dev libpcap-dev boost-dev boost-static

RUN \
  (cd behavioral-model && \
    sed -i '/_constants.cpp/d ; /_constants.h/d' \
      thrift_src/Makefile.am \
      targets/psa_switch/Makefile.am \
      targets/simple_switch/Makefile.am \
      pdfixed/Makefile.am \
      && \
    ./autogen.sh && \
    ./configure \
      --disable-debugger \
      --without-nanomsg \
      --with-pi \
      LDFLAGS=-static && \
    make -j$(nproc) LDFLAGS=-all-static && \
    make install \
  )

# Install P4C
# TODO: Broken on musl right now, issues filed
#RUN apk add --update cmake make gcc g++ python3 flex bison \
#  protobuf-dev grpc-dev boost-dev gc-dev gmp-dev llvm-dev
#
#RUN \
#  (cd p4c && \
#      mkdir build && \
#      cd build && \
#      cmake .. && \
#      make -j$(nproc) && \
#      make install \
#  )

FROM scratch
WORKDIR /opt/p4

COPY --from=builder /usr/local/bin/simple_switch .
#COPY --from=builder /usr/local/bin/p4c .

ENTRYPOINT ["/opt/p4/p4c"]
