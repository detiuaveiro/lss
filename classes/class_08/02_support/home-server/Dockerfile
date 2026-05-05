FROM alpine:latest

RUN apk add --no-cache openssh rsync 

RUN ssh-keygen -A

RUN adduser -D -s /bin/sh student && \
    echo "student:studentpass" | chpasswd

RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "Port 2222" >> /etc/ssh/sshd_config

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D", "-e"]
