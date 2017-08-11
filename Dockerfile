FROM ruby:2.4.1-onbuild

RUN apt-get update \
             && apt-get install -y --no-install-recommends \
                    ca-certificates \
                    bzip2 \
                    libfontconfig \
             && apt-get clean \
             && rm -rf /var/lib/apt/lists/*

RUN set -x  \
                # Install official PhantomJS release
             && apt-get update \
             && apt-get install -y --no-install-recommends \
                    curl \
             && mkdir /tmp/phantomjs \
             && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
                    | tar -xj --strip-components=1 -C /tmp/phantomjs \
             && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
                # Install dumb-init (to handle PID 1 correctly).
                # https://github.com/Yelp/dumb-init
             && curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb \
             && dpkg -i /tmp/dumb-init.deb \
                # Clean up
             && apt-get purge --auto-remove -y \
                    curl \
             && apt-get clean \
             && rm -rf /tmp/* /var/lib/apt/lists/*

COPY server.rb /usr/src/app
COPY myActions.rb /usr/src/app
COPY myFinders.rb /usr/src/app

COPY private /usr/src/app
COPY tmp /usr/src/app

RUN gem install webshot

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ENV RACK_ENV production

CMD ["ruby", "server.rb"]