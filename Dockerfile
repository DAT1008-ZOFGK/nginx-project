FROM nginx:1.28.0-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
