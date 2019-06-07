FROM       alpine
MAINTAINER Mauricio Araya

ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
ENV JEKYLL_ENV=production
ENV LC_ALL=en_US

RUN apk update
RUN apk add --update zlib-dev build-base libxml2-dev libxslt-dev readline-dev libffi-dev ruby-dev yaml-dev zlib-dev libffi-dev

RUN apk add --update zlib libxml2 ruby-io-console readline libxslt ruby yaml libffi ruby-irb ruby-json ruby-rake ruby-rdoc git \
    openssl tzdata bash python3-dev nodejs nodejs-npm

RUN npm install -g execjs

RUN apk add --update openssh

RUN rm -rf /var/cache/apk/*

RUN yes | gem install --force --no-ri --no-rdoc jekyll rouge jemoji jekyll-paginate
RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G jekyll jekyll

RUN yes | gem install bundler --no-ri --no-rdoc

RUN yes | gem install --force --no-ri --no-rdoc html-proofer RedCloth kramdown jemoji minima csspool listen \
          github-pages \
          jekyll-sitemap jekyll-mentions jekyll-coffeescript jekyll-sass-converter jekyll-redirect-from \
          jekyll-paginate jekyll-compose jekyll-feed jekyll-docs jekyll-github-metadata jekyll-minifier
          #octopress-minify-html


RUN apk add --no-cache python3 && \
    pip3 install --upgrade pip setuptools && \
    pip3 install --upgrade awscli && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    rm -r /root/.cache

RUN mkdir /home/share

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
