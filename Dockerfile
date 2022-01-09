FROM ubuntu:focal

# Add entrypoint
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Add NodeJS repository
RUN echo "deb [trusted=yes] http://deb.nodesource.com/node_16.x focal main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src [trusted=yes] http://deb.nodesource.com/node_16.x focal main" >> /etc/apt/sources.list.d/nodesource.list

# Add PocketMine custom PHP
ADD https://jenkins.pmmp.io/job/PHP-8.0-Aggregate/lastSuccessfulBuild/artifact/PHP-8.0-Linux-x86_64.tar.gz /opt/php.tar.gz
RUN cd /opt && tar -xzvf php.tar.gz && rm php.tar.gz && \
    EXTENSION_DIR=$(find "/opt/bin" -name *debug-zts*) && \
    grep -q '^extension_dir' /opt/bin/php7/bin/php.ini && sed -i'bak' "s{^extension_dir=.*{extension_dir=\"$EXTENSION_DIR\"{" /opt/bin/php7/bin/php.ini || echo "extension_dir=\"$EXTENSION_DIR\"" >> /opt/bin/php7/bin/php.ini

# Java & Python & NodeJS Installation
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y openjdk-8-jdk openjdk-16-jdk openjdk-17-jdk curl unzip python3 python3-pip nodejs

# Pterodactyl Setup (Create container user)
RUN adduser --disabled-password --home /home/container container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash","/entrypoint.sh"]