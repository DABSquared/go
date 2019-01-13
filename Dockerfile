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
 && mkdir -p $LIBPOSTAL_DATA \
 && git clone https://github.com/nigelhorne/libpostal.git \
 && cd libpostal \
  && echo "ACLOCAL_AMFLAGS = -I m4" >> Makefile.am \
  && echo "AC_CONFIG_MACRO_DIR([m4])" >> configure.ac \
  && mkdir -p m4 \
 && sed -i -e 's/\(\s*.*\/libpostal_data\s*download\s*all\s*\$(datadir)\/libpostal\)/#\1/g' src/Makefile.am \
 && ./bootstrap.sh \
 && if [ $arch = "amd64" ]; then ./configure --prefix=/usr --datadir=$LIBPOSTAL_DATA; else ./configure --prefix=/usr --datadir=$LIBPOSTAL_DATA --enable-sse2=no --with-cflags-scanner-extra="-march=armv8-a"; fi   \
 && echo "dan-make" \
 && make -j \
 && make install \
 && cd / \
 && /usr/bin/libpostal_data download all $LIBPOSTAL_DATA/libpostal \
 && rm -rf /tmp/src

COPY ./docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
