FROM debian:jessie
MAINTAINER Frank Wegener <wegener-it@cc-email.eu>

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get update 


RUN { \
	usermod -u 560 mail; \
	groupmod -g 560 mail; \
}

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get install --assume-yes \
        dovecot-core dovecot-imapd dovecot-pop3d \
        sudo

RUN apt-get clean

RUN { \
        ln --symbolic --force /dovecot/dovecot-conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf; \
        ln --symbolic --force /dovecot/dovecot-conf.d/10-logging.conf /etc/dovecot/conf.d/10-logging.conf; \
        ln --symbolic --force /dovecot/dovecot-conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf; \
        ln --symbolic --force /dovecot/dovecot-conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf; \
        ln --symbolic --force /dovecot/dovecot-conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf; \
        ln --symbolic --force /dovecot/dovecot-conf.d/auth-passwdfile.conf.ext /etc/dovecot/conf.d/auth-passwdfile.conf.ext; \
        ln --symbolic --force /dovecot/dovecot-conf.d/auth-static.conf.ext /etc/dovecot/conf.d/auth-static.conf.ext; \
        ln --symbolic --force /dovecot/dovecot-conf.d/auth-system.conf.ext /etc/dovecot/conf.d/auth-system.conf.ext; \
}

EXPOSE 993 995

ENTRYPOINT ["/usr/sbin/dovecot", "-F"]
