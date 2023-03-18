FROM alpine:3.17.2
RUN apk add --no-cache openssh linux-pam shadow acl &&\
    ssh-keygen -A
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
