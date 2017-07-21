FROM ruby:alpine

RUN apk update && apk add git curl-dev ruby-dev \
    build-base zlib-dev libxml2-dev libxslt-dev \
    tzdata yaml-dev postgresql-dev nodejs openssh && rm -rf /var/cache/apk/*
RUN mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    sed -i -e 's@^AuthorizedKeysFile.*@@g' /etc/ssh/sshd_config  && \
    echo -e "AuthorizedKeysFile\t.ssh/authorized_keys /etc/authorized_keys/%u" >> /etc/ssh/sshd_config && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app
RUN mv config/cable.yml.tt config/cable.yml
RUN mv config/secrets.yml.tt config/secrets.yml
RUN rake assets:precompile DATABASE_URL=postgres://localhost

COPY docker_entrypoint.sh /
RUN chmod +x /docker_entrypoint.sh
ENTRYPOINT ["/docker_entrypoint.sh"]

EXPOSE 3000
EXPOSE 22

CMD ["bundle", "exec", "puma", "-C", "./config/puma.rb"]
