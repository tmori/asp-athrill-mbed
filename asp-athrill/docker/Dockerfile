FROM ubuntu:20.04 as asp-athrill-v850

ARG DEBIAN_FRONTEND=noninteractive

ENV CMAKE_INSTALL_DIR /local
ENV PATH $PATH:/grpc/cmake/build
ENV PATH $PATH:/grpc/cmake/build/third_party/protobuf
ENV PATH $PATH:$CMAKE_INSTALL_DIR/bin

RUN apt-get update && apt-get install -y \
	git	\
	build-essential	\
	wget	\
	gcc	\
	g++	\
	ruby	\
	vim	\
	gem \
	libssl-dev libreadline-dev zlib1g-dev \
	make	\
	autoconf \
	automake \
	pkg-config \
	curl \
	net-tools \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN	wget -q -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.sh && \
	mkdir -p $CMAKE_INSTALL_DIR && \
	sh cmake-linux.sh --skip-license --prefix=$CMAKE_INSTALL_DIR && \
	rm cmake-linux.sh

# Install grpc
RUN mkdir -p /root/grpc-build && \
	cd /root/grpc-build && \
	git clone --recurse-submodules -b v1.35.0 https://github.com/grpc/grpc && \
	cd grpc && \
	git submodule update --init && \
	mkdir -p cmake/build && \
	cd cmake/build && \
	cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/grpc -DgRPC_BUILD_CSHARP_EXT=OFF -DOPENSSL_ROOT_DIR=/usr/local/boringssl -DCMAKE_PREFIX_PATH="/usr/local/cares;/usr/local/protobuf;/usr/local/zlib" && \
	make -j4 && \
	make install && \
	cd /root && \
	rm -rf grpc-build
ENV PATH /usr/local/grpc/bin:${PATH}

WORKDIR /root
RUN mkdir -p downloads 
RUN mkdir -p tools 
RUN mkdir -p workspace

WORKDIR /root/downloads 
RUN wget https://github.com/toppers/athrill-gcc-v850e2m/releases/download/v1.1/athrill-gcc-package.tar.gz 

WORKDIR /root/tools
RUN tar xzvf ../downloads/athrill-gcc-package.tar.gz 

WORKDIR /root/tools/athrill-gcc-package 
RUN	tar xzvf athrill-gcc.tar.gz && \
	rm -f athrill-gcc-package.tar.gz && \
	rm -f *.tar.gz
RUN echo 'export PATH=/root/tools/athrill-gcc-package/usr/local/athrill-gcc/bin/:${PATH}' >> /root/.bashrc

WORKDIR /root
RUN  mkdir -p /root/athrill-device
RUN git clone --depth 1 https://github.com/toppers/athrill.git && \
    git clone --depth 1 https://github.com/toppers/athrill-device.git && \
    git clone --depth 1 https://github.com/toppers/athrill-target-v850e2m.git && \
    git clone --recursive https://github.com/toppers/hakoniwa-core.git
RUN  ln -s  /root/hakoniwa-core /root/workspace/hakoniwa-core

WORKDIR /root/athrill
RUN git pull

WORKDIR /root/athrill-device
RUN git pull


WORKDIR /root/athrill-target-v850e2m
RUN git pull

WORKDIR /root/hakoniwa-core/impl/asset/client/build
RUN git pull
RUN  bash build.bash cpp clean && \
	bash build.bash cpp


WORKDIR /root/athrill-target-v850e2m/build_linux
RUN make clean && \
    make timer32=false serial_fifo_enable=true vdev_disable=true skip_clock_bugfix=true supress_detect_error=true reuse_port=true
WORKDIR /root/athrill-device/device/hakoniwa
WORKDIR /root/athrill-device/device/hakoniwa/build
RUN  bash build.bash

RUN echo 'export PATH=/root/athrill/bin/linux:${PATH}' >> ~/.bashrc
RUN echo 'export PATH=/root/workspace/bin:${PATH}' >> ~/.bashrc
RUN echo 'export PATH=/root/hakoniwa-core/impl/asset/client/build/cpp:${PATH}' >> ~/.bashrc
RUN mkdir workspace

WORKDIR /root/workspace
RUN  ln -s  /root/athrill /root/workspace/athrill
#CMD ["/root/workspace/proxy/start_proxy.bash"]
