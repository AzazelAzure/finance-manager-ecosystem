FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

# We expect certs to be mounted via volumes in docker-compose.yml
# but we create the directory just in case.
RUN mkdir -p /etc/nginx/certs
