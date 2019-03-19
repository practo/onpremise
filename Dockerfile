FROM sentry:9.0-onbuild

ENTRYPOINT [ "/usr/src/sentry/docker-entrypoint.sh" ]
RUN chmod +x /usr/src/sentry/docker-entrypoint.sh
