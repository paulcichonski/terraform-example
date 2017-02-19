FROM library/ruby:latest

RUN apt-get update && apt-get install -y netcat

RUN gem install \
    turnip \
    turnip_formatter \
    rspec_junit_formatter \
    byebug \
    rspec-instafail

ENV DOCKER_VERSION 1.12.6
RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz | tar -xzvf - --strip-components=1 -C /usr/bin docker/docker
RUN chmod a+x /usr/bin/docker

WORKDIR /opt/project
ENTRYPOINT ["rspec", "--require", "./blackbox-test/spec_helper.rb"]
CMD ["--pattern", "blackbox-test/features/**/*.feature"]
