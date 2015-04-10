# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Sam Alba <sam@docker.com>
# DESCRIPTION:    Image with docker-registry project and dependecies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

# Alpine Linux
FROM gliderlabs/alpine

RUN apk --update add \
    swig \
    python \
    python-dev \
    openssl-dev \
    libevent-dev \
    curl \
    gcc \
    zlib-dev \
    libc-dev \
    xz-dev \
    py-pip

COPY . /docker-registry
COPY ./config/boto.cfg /etc/boto.cfg

# Install core
RUN pip install /docker-registry/depends/docker-registry-core

# Install registry
RUN pip install file:///docker-registry#egg=docker-registry[bugsnag,newrelic,cors]

#RUN patch \
# $(python -c 'import boto; import os; print os.path.dirname(boto.__file__)')/connection.py \
# < /docker-registry/contrib/boto_header_patch.diff

ENV DOCKER_REGISTRY_CONFIG /docker-registry/config/config_sample.yml
ENV SETTINGS_FLAVOR dev

EXPOSE 5000

CMD ["docker-registry"]
