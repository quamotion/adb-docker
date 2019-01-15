FROM ubuntu:xenial

ARG LIBUSB_VERSION=1.0.22
ARG ADK_PLATFORM_TOOLS_VERSION=26.0.1

RUN apt-get update \
&& apt-get install -y git wget unzip \
&& apt-get install -y autoconf autotools-dev gcc g++ libssl-dev libtool make pkg-config \
# Delete all the apt list files since they're big and get stale quickly
&& rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN wget https://github.com/libusb/libusb/archive/v$LIBUSB_VERSION.tar.gz -O libusb-v$LIBUSB_VERSION.tar.gz \
&& tar xvf libusb-v$LIBUSB_VERSION.tar.gz \
&& wget https://www.nuget.org/api/v2/package/runtime.linux.adk-platform-tools/$ADK_PLATFORM_TOOLS_VERSION -O runtime.linux.adk-platform-tools-$ADK_PLATFORM_TOOLS_VERSION.nupkg \
&& unzip runtime.linux.adk-platform-tools-$ADK_PLATFORM_TOOLS_VERSION.nupkg \
&& chmod +x /src/runtimes/linux/native/adb

WORKDIR /src/libusb-$LIBUSB_VERSION
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
