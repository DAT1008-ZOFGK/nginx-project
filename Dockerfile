FROM nginx:1.29.5-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
