FROM nginx:1.27.1-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
