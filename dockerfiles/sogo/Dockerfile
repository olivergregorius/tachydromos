ARG LIBWBXML_VERSION=0.11.8
ARG APPVERSION

FROM debian:bullseye-slim AS builder
ENV DEBIAN_FRONTEND='noninteractive'
ARG LIBWBXML_VERSION
ARG APPVERSION
ARG TARGETARCH

RUN echo 'deb http://deb.debian.org/debian bullseye-backports main' >> /etc/apt/sources.list \
    && apt update && apt install -y \
    git \
    unzip \
    make \
    cmake \
    gnustep-make \
    debhelper \
    checkinstall \
    libgnustep-base-dev \
    gobjc \
    libexpat1-dev \
    libxml2-dev \
    libldap2-dev \
    libssl-dev \
    libpq-dev \
    libmariadb-dev-compat \
    autotools-dev \
    libsodium-dev \
    libmemcached-dev \
    libcurl4-openssl-dev \
    liblasso3-dev \
    libzip-dev \
    libytnef0-dev \
    python

# libwbxml2-dev
RUN mkdir /sogobuild && cd /sogobuild \
    && git clone --depth 1 --branch libwbxml-${LIBWBXML_VERSION} https://github.com/libwbxml/libwbxml.git \
    && cd libwbxml \
    && mkdir build && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make \
    && for PKGNAME in 'libwbxml2-0' 'libwbxml2-dev'; do checkinstall \
        --default \
        --install=no \
        --pkgname=${PKGNAME} \
        --pkgversion=${LIBWBXML_VERSION} \
        --maintainer=oliver@gregorius.dev \
        --pkgarch=${TARGETARCH} \
        --requires="zlib1g-dev, libexpat1-dev, libpopt-dev"; done \
    && cp libwbxml2-*_${LIBWBXML_VERSION}-1_${TARGETARCH}.deb /sogobuild/ \
    && cd /sogobuild && rm -r libwbxml \
    && apt install -y --no-install-recommends ./libwbxml2-dev_${LIBWBXML_VERSION}-1_${TARGETARCH}.deb

# SOPE
RUN cd /sogobuild \
    && git clone --depth 1 --branch SOPE-${APPVERSION} https://github.com/Alinto/sope.git \
    && cd sope \
    && cp -a packaging/debian debian \
    && ./debian/rules \
    && dpkg-buildpackage \
    && cd /sogobuild && rm -r sope \
    && apt install -y --no-install-recommends ./libsope*.deb

# SOGo
RUN cd /sogobuild \
    && git clone --depth 1 --branch SOGo-${APPVERSION} https://github.com/Alinto/sogo.git \
    && cd sogo \
    && cp -a packaging/debian debian \
    && sed -i 's/dh_shlibdeps/dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info/' debian/rules \
    && ./debian/rules \
    && dpkg-buildpackage -b \
    && cd /sogobuild && rm -r sogo

FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND='noninteractive'
ARG LIBWBXML_VERSION
ARG APPVERSION
ARG TARGETARCH

# Using root user for setting up the image
USER root

### Prepare and install environment
RUN apt update && apt install -y \
    python3 \
    python3-pip \
    rsync

RUN pip3 install jinja2 pyyaml

COPY --from=builder /sogobuild/libwbxml2-0_${LIBWBXML_VERSION}-1_${TARGETARCH}.deb /sogopackages/
COPY --from=builder /sogobuild/libsope*.deb /sogopackages/
COPY --from=builder /sogobuild/sope*.deb /sogopackages/
COPY --from=builder /sogobuild/sogo*.deb /sogopackages/

# Bugfix https://www.sogo.nu/bugs/view.php?id=4776
RUN mkdir -p /usr/share/doc/sogo && touch /usr/share/doc/sogo/empty.sh \
    && apt install -y --no-install-recommends /sogopackages/*.deb \
    && rm -r /sogopackages \
    && chmod 0770 /etc/sogo \
    && chmod 0664 /etc/sogo/sogo.conf

USER sogo

# SOGo
EXPOSE 20000

ENTRYPOINT []
CMD []
