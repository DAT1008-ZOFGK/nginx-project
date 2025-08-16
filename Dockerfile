FROM nginx:1.29.1-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
