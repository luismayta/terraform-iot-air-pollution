#
# See ./CONTRIBUTING.rst
#

OS := $(shell uname)
.PHONY: help
.DEFAULT_GOAL := help

HAS_PIP := $(shell command -v pip;)
HAS_PIPENV := $(shell command -v pipenv;)

ifdef HAS_PIPENV
	PIPENV_RUN:=pipenv run
	PIPENV_INSTALL:=pipenv install
else
	PIPENV_RUN:=
	PIPENV_INSTALL:=
endif

TEAM:=ulima
PROJECT := terraform-iot-air-pollution
PROJECT_PORT := 8000
KEYNAME:=air-pollution

PYTHON_VERSION=3.7.3
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL ?=/bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=🍺️
MESSAGE_HAPPY:="Done! ${MESSAGE}, Now Happy Coding"
SOURCE_DIR=$(ROOT_DIR)/
PROVISION_DIR:=$(ROOT_DIR)/provision
FILE_README:=$(ROOT_DIR)/README.rst
KEYBASE_PATH ?= /keybase/team/${TEAM}
KEYS_PEM_DIR:=${KEYBASE_PATH}/pem
KEYS_KEY_DIR:=${KEYBASE_PATH}/key
KEYS_CSR_DIR:=${KEYBASE_PATH}/csr
KEYS_PUB_DIR:=${KEYBASE_PATH}/pub
KEYS_PRIVATE_DIR:=${KEYBASE_PATH}/private/key_file/${PROJECT}
PASSWORD_DIR:=${KEYBASE_PATH}/password
PATH_DOCKER_COMPOSE:=docker-compose.yml -f provision/docker-compose
DOCKER_SERVICE:=app

docker-compose:=$(PIPENV_RUN) docker-compose

include provision/make/*.mk

help:
	@echo '${MESSAGE} Makefile for ${PROJECT}'
	@echo ''
	@echo 'Usage:'
	@echo '    environment               create environment with pyenv'
	@echo '    clean                     remove files of build'
	@echo '    setup                     install requirements'
	@echo ''
	@make aws.help
	@make alias.help
	@make docker.help
	@make test.help
	@make keybase.help
	@make terragrunt.help
	@make utils.help

clean:
	@echo "=====> clean files unnecessary for ${TEAM}..."
ifneq (Darwin,$(OS))
	@sudo rm -rf .tox *.egg *.egg-info dist build .coverage .eggs .mypy_cache
	@sudo rm -rf docs/build
	@sudo find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
else
	@rm -rf .tox *.egg *.egg-info dist build .coverage .eggs .mypy_cache
	@rm -rf docs/build
	@find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
endif
	@echo "=====> end clean files unnecessary for ${TEAM}..."

setup: clean
	@echo "=====> install packages..."
	$(PIPENV_INSTALL) --dev
	$(PIPENV_RUN) pre-commit install
	@cp -rf provision/git/hooks/prepare-commit-msg .git/hooks/
	@[[ ! -e ".env" ]] && [[ -e ".env-sample" ]] || cp -rf .env-sample .env
	@echo ${MESSAGE_HAPPY}

environment: clean
	@echo "=====> loading virtualenv ${PYENV_NAME}..."
	@pipenv --venv || $(PIPENV_INSTALL) --python ${PYTHON_VERSION}
