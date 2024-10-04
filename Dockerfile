FROM n8nio/base:20
COPY ./entrypoint.sh /entrypoint.sh
RUN chown -R node /entrypoint.sh
USER node
RUN mkdir -p ~/.pnpm-store && pnpm config set store-dir ~/.pnpm-store --global
ENTRYPOINT ["/entrypoint.sh"]
