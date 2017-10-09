FROM elixir:1.5.2

RUN apt-get update
RUN apt-get install -y postgresql-client
RUN apt-get autoclean

ENV WORK_DIR /tmp/weblio_scraping
ENV APP_DIR /opt

WORKDIR ${WORK_DIR}

COPY . ${WORK_DIR}

ENV MIX_ENV=prod

RUN mix local.hex --force
RUN mix deps.get --only prod
RUN mix compile

RUN mix release

RUN tar xvf rel/weblio_scraping/releases/0.0.1/weblio_scraping.tar.gz -C ${APP_DIR}

WORKDIR ${APP_DIR}
RUN rm -rf ${WORK_DIR}

COPY script/wait-for-postgres.sh .

ENV PORT=80

CMD bin/weblio_scraping foreground
