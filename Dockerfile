FROM onixldlc/nginx-ui:base AS nginx-ui-base
FROM nginx:alpine3.21 AS runner
COPY --from=nginx-ui-base /bin/nginx-ui /usr/local/bin/nginx-ui
COPY ./nginx_ui-entrypoint.sh /nginx_ui-entrypoint.sh

COPY resources/nginx.conf /etc/nginx/nginx.conf
COPY resources/default-sites /sites

RUN chmod +x /nginx_ui-entrypoint.sh

RUN mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/streams-enabled && \
    mkdir -p /etc/nginx/streams-available

RUN cp -r /etc/nginx/ /etc/nginx-default/

# recreate access.log and error.log
RUN rm -f /var/log/nginx/access.log && \
    touch /var/log/nginx/access.log && \
    rm -f /var/log/nginx/error.log && \
    touch /var/log/nginx/error.log

WORKDIR /etc/nginx-ui

ENTRYPOINT ["/nginx_ui-entrypoint.sh"]