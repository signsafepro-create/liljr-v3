FROM node:20-slim
WORKDIR /app
COPY package.json tsconfig.json ./
COPY src ./src
RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["node", "dist/server.js"]
