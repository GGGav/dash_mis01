FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils dialog curl sudo vim iputils-ping ca-certificates build-essential ruby ruby-dev tzdata
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get -y install nodejs && \
    apt-get -y clean
ENV TZ 'Europe/London'
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN gem install bundler smashing

RUN groupadd --gid 3030 --system smashing && \
    useradd --home-dir /smashing --create-home --gid smashing --system --shell /bin/bash --uid 3030 smashing

COPY run.sh /smashing

RUN cd / && \
    smashing new smashing && \
    mkdir /smashing/certs && \
    mkdir /smashing/config && \
    chown -R smashing:smashing /smashing && \
    ln -s /smashing/dashboards /dashboards && \
    ln -s /smashing/jobs /jobs && \
    ln -s /smashing/assets /assets && \
    ln -s /smashing/lib /lib-smashing && \
    ln -s /smashing/public /public && \
    ln -s /smashing/widgets /widgets && \
    ln -s /smashing/certs /certs && \
    mv /smashing/config.ru /smashing/config/config.ru && \
    ln -s /smashing/config/config.ru /smashing/config.ru && \
    ln -s /smashing/config /config && \
    chown -R smashing:smashing /smashing && \
    chmod 770 /smashing/run.sh

COPY Gemfile /smashing

USER smashing
VOLUME /dashboards /jobs /config /public /widgets /assets /certs

ENV PORT 3030
EXPOSE $PORT
WORKDIR /smashing

CMD ["/smashing/run.sh"]
#CMD ["/bin/bash"]

