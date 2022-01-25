FROM nginx:latest

COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY app/public /var/www/public/
