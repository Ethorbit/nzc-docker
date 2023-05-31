FROM ethorbit/input-output-envsubst:v1.0
ARG FILE_EXTENSION="conf"
ENV FILE_EXTENSION=${FILE_EXTENSION}
ENV ADMIN_EMAIL="admin@example.org"
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
