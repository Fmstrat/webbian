FROM debian:12

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
    
RUN \
    echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections; \
    apt-get update -y; \
    apt-get install -y \
        xfce4 \
        dbus-x11 \
        software-properties-common \
        expect \
        vim \
        xterm \
        wget \
        curl \
        ssh \
        iputils-ping \
        psmisc \
        tigervnc-standalone-server \
        tigervnc-xorg-extension \
        tigervnc-viewer \
        python3 \
        python3-numpy \
        xdotool \
        git \
        firefox-esr; \
    apt-get clean -y;

RUN \    
    cd /; \
    git clone https://github.com/novnc/noVNC.git; \
    cd /noVNC/utils; \
    git clone https://github.com/novnc/websockify;
    
WORKDIR /noVNC

ADD init.sh /init.sh
ADD xstartup /root/.vnc/xstartup
RUN chmod 755 /init.sh /root/.vnc/xstartup;

CMD /init.sh
