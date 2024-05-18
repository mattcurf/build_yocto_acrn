FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
   apt upgrade -y --fix-missing && \
   apt -y install locales gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev zstd liblz4-tool file && \
  pip install --upgrade pip && \
  pip install pycrypto && \
  git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name" && \
  git config --global advice.detachedHead "false"

RUN ["locale-gen", "en_US.UTF-8"]
RUN ["dpkg-reconfigure", "locales"]
RUN useradd --create-home -s /bin/bash user
WORKDIR /home/user
USER user
RUN mkdir /home/user/.ssh && mkdir /home/user/bin
COPY --chown=user bashrc /home/user/.bashrc

CMD ["/bin/bash"]
