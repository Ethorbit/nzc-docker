FROM alpine:latest
ARG TZ
ENV TZ=${TZ}
RUN apk add --no-cache openssh tzdata &&\
    ssh-keygen -A
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
