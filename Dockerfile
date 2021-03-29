FROM ruby:2.5.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y build-essential npm nodejs yarn
RUN gem install bundler -v 2.2.15

ENV APP_HOME /hdm
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/
RUN bundle config set --local path 'vendor/bundle' && bundle config set --local without 'development test' && bundle install
RUN yarn install --check-files

ADD . $APP_HOME

EXPOSE 3000

CMD ["/hdm/bin/entry.sh"]
