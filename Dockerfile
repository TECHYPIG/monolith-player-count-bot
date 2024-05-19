# Stage 1: Build
FROM node:18-alpine as build

WORKDIR /code
RUN apk add --no-cache git
COPY . .
RUN npm ci && npm run build

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app
RUN apk add --no-cache --virtual build-dependencies git
COPY package.json .
RUN npm install --only=production
RUN apk del build-dependencies
COPY --from=build /code/dist/ .

CMD ["node", "/app/index.js"]
