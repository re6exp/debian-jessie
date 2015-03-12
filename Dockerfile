# Oracle JRE 8 for Debian Jessie
#
# URL: https://github.com/re6exp/debian-jessie-oracle-jre-8
#
# Reference:  http://www.duinsoft.nl/packages.php?t=en
#
# Version     0.1
#


FROM debian:jessie

# Space separated list of first part encoding type in /etc/locale.gen

ENV LOCALES_DEF ru_RU.UTF-8 en_US.UTF-8

ENV LOCALE_BASE ''


RUN echo " Update packages and install locales dpkg:" && \
    apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -o Dpkg::Options::='--force-confnew' install locales -y


# Comment out possible uncommented locales before proceeding.
# Uncomment the necessary locales (LOCALES_DEF)

RUN echo " Set locales:" && \
    sed -i '/^\s/s/^/#/g' /etc/locale.gen &&\
    set -- junk $LOCALES_DEF \
    shift; \
    for THE_LOCALE in $LOCALES_DEF; \
        do sed -i "/$THE_LOCALE/s/^#//"  /etc/locale.gen ;\
    done ;\
    \
    locale-gen && update-locale $LOCALE_BASE && cat /etc/locale.gen
    
RUN echo " Clean up:"  && \
    rm -rf /var/cache/update-sun-jre  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

CMD [""]
