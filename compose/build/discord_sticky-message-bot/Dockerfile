FROM ethorbit/discord_sticky-message-bot:latest
USER root
ARG PUID
ARG PGID
RUN usermod -u "$PUID" stickybot &&\
    groupmod -g "$PGID" stickybot
USER stickybot
