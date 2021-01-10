FROM nginx:latest

ENV NGINX_ROOT /usr/src/app/public
ENV NGINX_FPM_HOST 192.168.33.10
ENV NGINX_FPM_PORT 9000

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY fpm-template.conf /etc/nginx/fpm.tmpl

RUN rm -f /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]