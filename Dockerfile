FROM node:8.1.3-alpine

LABEL authors="hoatle <hoatle@teracy.com>"

RUN mkdir -p /opt/app

ENV TERM=xterm APP=/opt/app

# add more arguments from CI to the image so that `$ env` should reveal more info
ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_BUILD_TIME
ARG NODE_ENV

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
    CI_BUILD_TIME=$CI_BUILD_TIME NODE_ENV=$NODE_ENV

WORKDIR $APP

ADD package.json yarn.lock $APP/

RUN yarn install && \
    yarn global add pm2 && \
    yarn cache clean

ADD . $APP

CMD ["sh", "run-prod.sh"]
