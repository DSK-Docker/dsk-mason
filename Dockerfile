FROM debian:stable-slim

LABEL maintainer "Dschinghis Kahn"

####################################################
######### DEFAULT VALUES                 ###########
####################################################
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2

####################################################
######### INSTALLING APACHE              ###########
####################################################
RUN \
  apt-get update && \
  apt-get install -y \
    apache2 \
    apache2-dev \
    libapache-dbi-perl \
    libapache-dbilogger-perl \
    libapache2-mod-apreq2 \
    libapache2-mod-fcgid \
    libapache2-mod-perl2 \
    libapache2-mod-perl2-dev \
    libapache2-request-perl \
    libapreq2-dev \
    libxml2-dev

####################################################
######### INSTALLING MASON               ###########
####################################################
RUN \
  apt-get install -y \
    cpanminus && \
  cpanm -qf HTML::Mason && \
  apt-get remove -y \
    cpanminus

####################################################
######### SETUP APACHE                   ###########
####################################################
RUN \
  a2dismod mpm_event && \
  a2enmod mpm_prefork cgi fcgid

####################################################
######### SETUP FILES & FOLDERS          ###########
####################################################
RUN \
  mkdir /etc/apache2/mason && \
  chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP /etc/apache2/mason
COPY mason-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY init index-default.mhtml /

####################################################
######### INSTALLING NETCAT              ###########
####################################################
RUN \
  apt-get install -y \
    netcat

####################################################
######### CLEANUP                        ###########
####################################################
RUN rm -rf /tmp/* /root/.cpanm

####################################################
######### DEFINING VOLUMES               ###########
####################################################
VOLUME /mnt/site

EXPOSE 80

HEALTHCHECK CMD nc -z localhost 80 || exit 1

CMD ["/init"]
