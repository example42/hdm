FROM ruby:2.5.8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y build-essential npm nodejs yarn

ENV APP_HOME /hdm
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/
RUN bundle install --without development test
RUN yarn install --check-files

ADD . $APP_HOME

EXPOSE 3000

CMD ["/hdm/bin/entry.sh"]
