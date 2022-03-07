FROM node:alpine

WORKDIR /app

RUN apk --no-cache add curl

ADD package.json .
RUN npm install

ADD . .

CMD node index.js