FROM ubuntu:16.04

WORKDIR /root

RUN apt-get update -y \
  && apt-get install -y \
  curl \
  gnome-panel \
  gnome-settings-daemon \
  gnome-terminal \
  metacity \
  nautilus \
  net-tools \
  openssh-server \
  python \
  ubuntu-desktop\
  unity-tweak-tool \
  vnc4server \
  && mkdir /var/run/sshd \
  && mkdir -p .ssh

#RUN echo 'root:root' |chpasswd
COPY key.pub .ssh/authorized_keys
COPY xstartup .vnc/xstartup
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && vncserver :1

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
