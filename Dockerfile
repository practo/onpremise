FROM sentry:9.1-onbuild

ENTRYPOINT [ "/usr/src/sentry/docker-entrypoint.sh" ]
RUN chmod +x /usr/src/sentry/docker-entrypoint.sh

USER sentry
