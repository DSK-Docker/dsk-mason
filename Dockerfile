FROM jackiig/html-mason:20180423

LABEL maintainer "Dschinghis Kahn"

RUN mkdir /etc/apache2/mason
RUN chown www-data:www-data /etc/apache2/mason

HEALTHCHECK CMD nc -z localhost 80 || exit 1

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
