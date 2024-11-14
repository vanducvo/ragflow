FROM node:22.11.0-bullseye AS builder

WORKDIR /ragflow

COPY ./docs ./docs

WORKDIR /ragflow/web

COPY ./web/package-lock.json ./package-lock.json

COPY ./web/package.json ./package.json

RUN npm install

COPY ./web/ ./

RUN npm run build

FROM nginx:1.27.2-bookworm

ENV RAGFLOW_SERVER_API_HOST=0.0.0.0

COPY --from=builder /ragflow/web/dist /ragflow/web/dist

COPY ./distribution/docker/web/nginx/nginx.conf /etc/nginx/nginx.conf

COPY ./distribution/docker/web/nginx/proxy.conf /etc/nginx/proxy.conf

COPY ./distribution/docker/web/nginx/ragflow.conf.template /etc/nginx/templates/ragflow.conf.template