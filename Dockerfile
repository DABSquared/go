ARG target
FROM $target/golang:stretch

ARG arch
ENV ARCH=$arch

COPY qemu-$ARCH-static* /usr/bin/


#Add in libpostal
ENV LIBPOSTAL_DATA=/data

#Add in libpostal
RUN apt-get update \
 && apt-get install -y curl autoconf automake libtool pkg-config \
 && mkdir -p /tmp/src \
 && cd /tmp/src \
 && git clone https://github.com/openvenues/libpostal.git \
 && cd libpostal \
 && ./bootstrap.sh \
 && echo "dan-configure" \
 && if [ $arch = "amd64" ]; then ./configure --prefix=/usr --datadir=/data; else ./configure --prefix=/usr --datadir=/data --enable-sse2=no; fi   \
 && echo "dan-make" \
 && make -j \
  && echo "dan-make-install" \
 && make install \
 && cd / \
 && /usr/bin/libpostal_data download all $LIBPOSTAL_DATA/libpostal

COPY ./docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
