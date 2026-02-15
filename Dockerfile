FROM alpine:latest

# Install dependencies
RUN apk add --no-cache openssh sshpass bash

# Generate host keys and silence login banners
RUN ssh-keygen -A && \
    truncate -s 0 /etc/motd /etc/issue && \
    echo "PrintLastLog no" >> /etc/ssh/sshd_config && \
    echo "PrintMotd no" >> /etc/ssh/sshd_config

# Add legacy SSH cypher and key exchange algorithms
RUN echo "KexAlgorithms +diffie-hellman-group1-sha1,diffie-hellman-group-exchange-sha1" >> /etc/ssh/sshd_config && \
    echo "Ciphers +aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc" >> /etc/ssh/sshd_config && \
    echo "HostKeyAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config && \
    echo "PubkeyAcceptedAlgorithms +ssh-rsa" >> /etc/ssh/sshd_config

# Copy the scripts and make them executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY bridge.sh /usr/local/bin/bridge.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/bridge.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
