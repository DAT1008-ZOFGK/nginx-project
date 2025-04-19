FROM nginx:1.27.5-alpine

COPY ./src /usr/share/nginx/html

EXPOSE 80
