FROM nginx:alpine3.21 AS runner
COPY --from=backend-builder /build/nginx-ui /usr/local/bin/nginx-ui
COPY ./nginx_ui-entrypoint.sh /nginx_ui-entrypoint.sh

COPY resources/nginx.conf /usr/local/etc/nginx/nginx.conf
COPY resources/nginx-ui.conf /usr/local/etc/nginx/conf.d/nginx-ui.conf

RUN chmod +x /nginx_ui-entrypoint.sh

RUN mkdir -p /etc/nginx/sites-enabled
RUN mkdir -p /etc/nginx/sites-available
RUN mkdir -p /etc/nginx/streams-enabled
RUN mkdir -p /etc/nginx/streams-available

RUN cp -r /etc/nginx/ /etc/nginx-default/

# recreate access.log and error.log
RUN rm -f /var/log/nginx/access.log && \
    touch /var/log/nginx/access.log && \
    rm -f /var/log/nginx/error.log && \
    touch /var/log/nginx/error.log

WORKDIR /etc/nginx-ui

ENTRYPOINT ["/nginx_ui-entrypoint.sh"]