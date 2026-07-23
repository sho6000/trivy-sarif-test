FROM node:14.0.0-alpine3.11

WORKDIR /app
COPY package.json .

CMD ["node", "-e", "console.log('vulnerable test app')"]
