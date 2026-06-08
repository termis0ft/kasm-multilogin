FROM kasmweb/ubuntu-noble-desktop:1.18.0-rolling-weekly

USER root

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR $HOME

COPY desktop-multiloginx-ubuntu-24.04-amd64.deb /tmp/multiloginx.deb

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    unzip \
    xz-utils \
    tar \
    gzip \
    bzip2 \
    file \
    procps \
    psmisc \
    lsof \
    strace \
    xdg-utils \
    dbus-x11 \
    python3 \
    python-is-python3 \
    libnss3 \
    libnspr4 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgtk-4-1 \
    libgbm1 \
    libdrm2 \
    libxshmfence1 \
    libxkbcommon0 \
    libasound2t64 \
    libxss1 \
    libsecret-1-0 \
    libnotify4 \
    libwebkit2gtk-4.1-0 \
    android-tools-adb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y flameshot kazam && \
    apt-get install -y --no-install-recommends /tmp/multiloginx.deb && \
    rm -f /tmp/multiloginx.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Multilogin requirement
RUN tee /etc/apt/sources.list.d/jammy.list <<'EOF'
deb http://archive.ubuntu.com/ubuntu jammy main universe
deb http://security.ubuntu.com/ubuntu jammy-security main universe
EOF

RUN apt update && apt install libwebkit2gtk-4.0-37
RUN rm /etc/apt/sources.list.d/jammy.list && apt update
# ---

# Optional: copy Multilogin desktop launcher to the user's desktop if the package installed one
RUN mkdir -p $HOME/Desktop && \
    find /usr/share/applications -iname '*multilogin*.desktop' -exec cp {} $HOME/Desktop/ \; || true && \
    chown -R 1000:0 $HOME && \
    $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME=/home/kasm-user
WORKDIR $HOME

RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
