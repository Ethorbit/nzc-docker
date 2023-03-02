FROM alpine:latest
ARG TZ
ENV TZ=${TZ}
RUN apk add --no-cache openssh linux-pam shadow tzdata &&\
    ssh-keygen -A
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
