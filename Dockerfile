FROM codenvy/debian_jdk8
MAINTAINER Larry TALLEY <larry.talley@gmail.com>
#Copied almost exactly from
#FROM webcenter/openjdk-jre:8
#MAINTAINER Sebastien LANGOUREAUX <linuxworkgroup@hotmail.com>

# Update distro and install some packages
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y python-testtools python-nose python-pip vim curl supervisor logrotate locales  && \
    sudo update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    sudo locale-gen en_US.UTF-8 && \
    sudo dpkg-reconfigure locales && \
    sudo rm -rf /var/lib/apt/lists/*

# Install stompy
RUN sudo pip install stomp.py

# Lauch app install
COPY assets/setup/ /app/setup/
RUN chmod +x /app/setup/install
RUN /app/setup/install

# Copy the app setting
COPY assets/entrypoint /app/entrypoint
COPY assets/run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Expose all port
EXPOSE 8161
EXPOSE 61616
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883
EXPOSE 61614

# Expose some folders
VOLUME ["/data/activemq"]
VOLUME ["/var/
