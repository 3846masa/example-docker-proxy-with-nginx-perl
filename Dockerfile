FROM nginx:alpine

RUN apk --no-cache add perl-json && \
    delgroup ping && \
    addgroup -g 999 docker && \
    addgroup nginx docker

COPY conf.d /etc/nginx/conf.d

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off; load_module /etc/nginx/modules/ngx_http_perl_module.so;"]
