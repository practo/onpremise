FROM {{ REGISTRY }}/sentry9:9.0.0-practo1-onbuild

ENTRYPOINT [ "/usr/src/sentry/docker-entrypoint.sh" ]
RUN chmod +x /usr/src/sentry/docker-entrypoint.sh

USER sentry
