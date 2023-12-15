FROM debian:11

ARG CROSS_TOOLCHAIN=gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

WORKDIR /root/

ADD z.tar.gz  $CROSS_TOOLCHAIN  /opt
ADD fengming.d.tar.gz  /opt
ADD pico-sdk.tar.gz pico-examples.tar.gz /root


ENV COMPILER4WHO=raspberrypi_pico_gcc_compiler
RUN cat <<-EOF >> .bashrc
alias who='echo $COMPILER4WHO'
export LANG=en_US.UTF-8

if [ -f /opt/fengming.d/mybashrc  ];then
    . /opt/fengming.d/mybashrc
fi

export PICO_SDK_PATH="/root/pico-sdk"
export PICO_TOOLCHAIN_PATH="/opt/gcc-arm-none-eabi-10.3-2021.10"
EOF

RUN cat <<-EOF > /etc/apt/sources.list
deb http://mirrors.163.com/debian/ bullseye main contrib 
deb http://mirrors.163.com/debian/ bullseye-updates main contrib
EOF

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y locales vim git wget tree bd file \
		build-essential lib32z1 libncurses5-dev \
		make cmake gcc-multilib 

RUN cp /etc/locale.gen /etc/locale.gen.bak;\
		echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen;\
		locale-gen

ENV PATH=$PATH:/opt/gcc-arm-none-eabi-10.3-2021.10/bin

CMD ["/bin/bash"]
