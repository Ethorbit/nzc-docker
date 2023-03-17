FROM alpine:latest
RUN apk add --no-cache openssh linux-pam shadow &&\
    ssh-keygen -A
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
