FROM golang:latest

RUN apt-get update && apt-get install -y curl autoconf automake libtool pkg-config git gcc build-essential

#Add in libpostal
RUN cd /var && git clone https://github.com/openvenues/libpostal && cd libpostal && mkdir data-dir && ./bootstrap.sh && ./configure --datadir=/var/data-dir &&  make -j4 && make install && ldconfig

RUN cd /var && git clone https://github.com/derekparker/delve && cd delve && make install

RUN wget https://github.com/golang/dep/releases/download/v0.3.2/dep-linux-amd64 && mv dep-linux-amd64 /usr/local/bin/dep && chmod a+x /usr/local/bin/dep
