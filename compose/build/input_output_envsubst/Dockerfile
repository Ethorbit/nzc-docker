FROM ethorbit/envsubst:latest
ARG FILE_EXTENSION="conf"
ENV FILE_EXTENSION=${FILE_EXTENSION}
COPY ./start.sh /start.sh
RUN chmod +x /start.sh
CMD [ "/start.sh" ]
