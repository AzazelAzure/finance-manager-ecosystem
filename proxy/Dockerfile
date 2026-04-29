FROM docker.io/library/nginx:alpine

COPY docker-entrypoint.d/20-resolver-from-resolv.sh /docker-entrypoint.d/20-resolver-from-resolv.sh
RUN chmod +x /docker-entrypoint.d/20-resolver-from-resolv.sh

COPY nginx.conf /etc/nginx/nginx.conf

# We expect certs to be mounted via volumes in docker-compose.yml
# but we create the directory just in case.
RUN mkdir -p /etc/nginx/certs
