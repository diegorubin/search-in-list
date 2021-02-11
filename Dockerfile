FROM nginx:stable-alpine-perl

RUN apk add perl-utils
RUN apk add perl-net-ssleay
RUN apk add perl-io-socket-ssl
RUN apk add perl-dev
RUN apk add gcc
RUN apk add musl-dev
RUN apk add make

RUN cpan install HTTP::Tiny

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir /etc/nginx/filters
COPY nginx/filter.pm /etc/nginx/filters/filter.pm

# Build and install search
RUN mkdir /build
COPY search /build/search

WORKDIR /build/search

RUN ./build.sh

COPY entries_list /tmp/entries_list

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
