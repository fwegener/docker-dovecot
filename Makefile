## For more examples of a Makefile based Docker container deployment see: https://github.com/ypid/docker-makefile

DOCKER_RUN_OPTIONS ?= --env "TZ=Europe/Berlin"

docker_dovecot_permanent_storage ?= /data/docker/mail-data
docker_dovecot_ssl_cert ?= /data/docker/etc/ssl/gwy2.crt
docker_dovecot_ssl_key  ?= /data/docker/etc/ssl/gwy2.key
docker_dovecot_servername ?= dovecot
image_dovecot ?= fwegener/dovecot

.PHONY: default start stop run build build-dev dovecot dovecot-dev rm-containers

default:
	@echo 'See Makefile and README.md'

start:
	docker start dovecot

stop:
	docker stop dovecot

run: dovecot

rm-containers:
	docker rm --force dovecot

build:
	docker build --no-cache=true --tag $(image_dovecot) .

build-dev:
	docker build --no-cache=false --tag $(image_dovecot) .


dovecot:
	-@docker rm --force "$@"
	docker run --detach \
		--name "$@" \
		$(DOCKER_RUN_OPTIONS) \
		--volume "$(docker_dovecot_permanent_storage)/data:/var/mail" \
		--volume "$(docker_dovecot_permanent_storage)/config:/dovecot" \
		--volume "$(docker_dovecot_permanent_storage)/log:/var/log/dovecot" \
		--volume "$(docker_dovecot_ssl_cert):/etc/ssl/certs/ssl-mail.pem:ro" \
		--volume "$(docker_dovecot_ssl_key):/etc/ssl/private/ssl-mail.key:ro" \
		--publish 993:993 \
		--publish 995:995 \
		$(image_dovecot)
