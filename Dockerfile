# Basic Unix course practice environment.
#
# This image is content-free: it contains NO course files and NO answers.
# Your cloned repository is paired with it at run time via the volume mount
# in the README's run command ( -v "$(pwd)":/work ), so the same image
# serves every student and every marker. Build once:
#
#   docker build -t unix-course .
#
FROM ubuntu:24.04

# The Ubuntu base image is "minimized": a dpkg exclude strips man pages from
# every package, and a shim diverted over /usr/bin/man prints a banner
# instead of running the real man. A unix course needs `man ls` to work, so
# drop the exclude, remove the shim and its diversion, reinstall the
# already-present core packages to restore their pages, then add the
# practice tools ( their pages install normally once the exclude is gone ).
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes \
    && if dpkg-divert --list /usr/bin/man | grep -q man.REAL; then \
        rm -f /usr/bin/man \
        && dpkg-divert --quiet --remove --rename /usr/bin/man; \
    fi \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --reinstall \
        bash \
        coreutils \
        findutils \
        grep \
        gzip \
        sed \
        tar \
        util-linux \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        file \
        iputils-ping \
        less \
        man-db \
        manpages \
        nano \
        net-tools \
        tree \
        unzip \
        vim \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Matches the mount point in the run command, so a shell always starts in
# the student's repo even if -w /work is omitted.
WORKDIR /work

CMD ["bash"]
