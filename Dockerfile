FROM alpine:3.5

ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.3.3
ENV CONFIGURE_OPTS --disable-install-doc

RUN apk update && \
    apk upgrade

RUN apk add --update gcc gnupg curl ruby bash procps musl-dev make linux-headers \
    zlib zlib-dev openssl openssl-dev libssl1.0 libffi-dev ruby-dev tar nodejs \
    readline-dev build-base git py2-pip && rm -rf /var/cache/apk/*


RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ${RBENV_ROOT} && \
    git clone --depth 1 https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build && \
    git clone --depth 1 git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset && \
    ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN rbenv install $RUBY_VERSION &&  rbenv global $RUBY_VERSION

RUN gem install rake -N --no-ri --no-rdoc && \
    gem install bundler --no-ri --no-rdoc && \
    gem install io-console --no-ri --no-rdoc  && \
    gem install html-proofer --no-ri --no-rdoc && \
    gem install github-pages -v '~> 39' --no-ri --no-rdoc && \
    gem install json --no-ri --no-rdoc

run pip install --upgrade pip awscli boto3 botocore

CMD ["/bin/bash"]
