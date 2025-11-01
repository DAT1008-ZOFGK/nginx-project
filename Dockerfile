FROM nginx:1.29.3-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
