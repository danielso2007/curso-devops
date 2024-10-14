FROM node:alpine
ENV PORT=3000
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
COPY ./ ./
EXPOSE 8081
CMD ["npm", "start"]