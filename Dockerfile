FROM node:14.0.0

WORKDIR /app
COPY package.json .

CMD ["node", "-e", "console.log('vulnerable test app')"]
