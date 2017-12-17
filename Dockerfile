FROM ubuntu:xenial

RUN apt-get update \
&& apt-get install -y git wget \
&& apt-get install -y autoconf autotools-dev gcc g++ libssl-dev libtool make pkg-config \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN wget https://github.com/libusb/libusb/archive/v1.0.21.tar.gz -O libusb-1.0.21.tar.gz \
&& tar xvf libusb-1.0.21.tar.gz

WORKDIR /src/libusb-1.0.21
RUN ./autogen.sh enable_udev=no --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

FROM ubuntu:xenial

WORKDIR /

COPY --from=0 /out/usr/ /usr/
