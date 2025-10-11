FROM nginx:1.29.2-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
