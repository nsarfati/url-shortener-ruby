UNAME := $(shell uname)
.PHONY: start-devenv stop-devenv clear-devenv
DEFAULT_TARGET: start-devenv

DEVENV_DOCKER_COMPOSE = REDIS_PORT=2003: docker-compose -p url-shortener -f $(shell pwd)/env/dev/docker-compose.yml
DEVENV_INTERACTIVE_REDIS = docker exec -it url-shortener_redis_1 redis-cli

start-devenv:
	$(DEVENV_DOCKER_COMPOSE) up -d --no-recreate

clear-devenv:
	$(DEVENV_DOCKER_COMPOSE) down -v --remove-orphans

redis-devenv:
	$(DEVENV_INTERACTIVE_REDIS)

update-dependencies:
	bundle install

run-locally:
	CONFIG_DIR=env/dev/ bundle exec rackup
