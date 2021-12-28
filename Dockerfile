FROM ubuntu:18.04

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
  apt-utils build-essential clang gdb gdbserver openssh-server rsync

# 安装指定版本的cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.sh \
  && sh cmake-3.22.1-linux-x86_64.sh --prefix=/usr --exclude-subdir

# Taken from - https://docs.docker.com/engine/examples/running_ssh_service/#environment-variables
RUN mkdir /var/run/sshd \
  && echo 'root:root' | chpasswd \
  && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# 22 for ssh server. 7777 for gdb server.
EXPOSE 22 7777

# Create dev user with password 'dev'
RUN useradd -ms /bin/bash dev \
  && echo 'dev:dev' | chpasswd

# Upon start, run ssh daemon
CMD ["/usr/sbin/sshd", "-D"]
