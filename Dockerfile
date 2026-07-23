FROM node:18

WORKDIR /app
COPY package.json .
RUN npm install

CMD ["node", "-e", "console.log('vulnerable test app')"]
