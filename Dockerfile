FROM python:3-alpine

WORKDIR /usr/src/netbox/
ADD requirements.txt /usr/src/netbox

# Install dependencies
RUN apk update && apk add \
      bash \
      sudo \
      graphviz \
      postgresql-client \
      ca-certificates \
      bash \
      wget \
      libxslt \
      libxml2 \
      libffi \
    && apk add --virtual builddeps \
      build-base \
      cyrus-sasl-dev \
      jpeg-dev \
      libffi-dev \
      libxml2-dev \
      libxslt-dev \
      openldap-dev \
      postgresql-dev \
      ttf-ubuntu-font-family \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del builddeps

ADD netbox /usr/src/netbox
# Change workdir
WORKDIR /usr/src/netbox/

# Create user
RUN addgroup -g 1000 netbox \
    && adduser -D -u 1000 -G netbox -h /usr/src/netbox netbox \
    && chown -Rh netbox:netbox /usr/src/netbox

# Setup entrypoint
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Expose ports
EXPOSE 8000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["runserver", "--insecure", "0.0.0.0:8000"]
