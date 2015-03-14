# Debian Jessie
#
# URL: https://github.com/re6exp/debian-jessie
#
# Version     0.1
#

FROM debian:jessie

# Space separated list of first part encoding type in /etc/locale.gen
# Locale should be in format: < locale_name.encoding >.

ENV LOCALES_DEF ru_RU.UTF-8 en_US.UTF-8


RUN echo " Update packages and install locales dpkg:" && \
    apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -o Dpkg::Options::='--force-confnew' install locales -y


# Comment out possible uncommented locales before proceeding.
# Uncomment the necessary locales (from LOCALES_DEF above)

RUN echo " Set locales:" && \
    sed -i '/^\s/s/^/#/g' /etc/locale.gen &&\
    set -- junk $LOCALES_DEF \
    shift; \
    for THE_LOCALE in $LOCALES_DEF; \
        do sed -i "/$THE_LOCALE/s/^#//"  /etc/locale.gen ;\
    done ;\
    \
    locale-gen &&  \
    \
    echo "'locales -a' are:" && locale -a  &&  \
    echo "'cat /etc/locale.gen', activated records are:"  &&  \
    cat /etc/locale.gen | grep -v "^\#.*" | grep -v "^$"


RUN echo " Clean up:"  &&  \
    apt-get clean  &&  \
    rm -rf /var/lib/apt/lists/*


CMD ["/bin/bash"]
