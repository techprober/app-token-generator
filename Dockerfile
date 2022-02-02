ARG FUNCTION_DIR=/function

FROM ruby:alpine

MAINTAINER Kevin YU

ARG FUNCTION_DIR

WORKDIR ${FUNCTION_DIR}
COPY ./handler.rb ./

RUN gem install jwt httparty

CMD [ "ruby", "handler.rb" ]

