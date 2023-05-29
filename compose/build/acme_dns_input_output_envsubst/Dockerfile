FROM ethorbit/input-output-envsubst:v1.0
ENV ADMIN_EMAIL="admin@example.org"
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
