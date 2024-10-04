FROM nginx:1.27.2-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
