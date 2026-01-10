FROM nginx:1.29.4-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
