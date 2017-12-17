FROM ubuntu:xenial

RUN apt-get update \
&& apt-get install -y git wget unzip \
&& apt-get install -y autoconf autotools-dev gcc g++ libssl-dev libtool make pkg-config \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN wget https://github.com/libusb/libusb/archive/v1.0.21.tar.gz -O libusb-1.0.21.tar.gz \
&& tar xvf libusb-1.0.21.tar.gz \
RUN wget https://www.nuget.org/api/v2/package/runtime.linux.adk-platform-tools/26.0.1 -O runtime.linux.adk-platform-tools-26.0.1.nupkg \
&& unzip runtime.linux.adk-platform-tools-26.0.1.nupkg

WORKDIR /src/libusb-1.0.21
RUN ./autogen.sh enable_udev=no --prefix=/usr \
&& make \
&& make install \
&& DESTDIR=/out make install

FROM ubuntu:xenial

WORKDIR /

COPY --from=0 /out/usr/ /usr/
COPY --from=0 /src/runtimes/linux/native/adb /usr/sbin

# Expose default ADB port
EXPOSE 5037

# Start the server by default
CMD ["/usr/sbin/adb", "-a", "-P", "5037", "server", "nodaemon"]
