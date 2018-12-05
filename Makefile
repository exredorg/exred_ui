MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
APP_NAME := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))

LOG_PREFIX = '${APP_NAME} | ${MIX_ENV}:'

.PHONY: dev prod cleandev cleanprod compile release run

dev: export MIX_ENV = dev
dev: cleandev compile

prod: export MIX_ENV = prod
prod: cleanprod compile

compile:
	@echo ${LOG_PREFIX} getting deps
	@mix deps.get 1>/dev/null
	@echo ${LOG_PREFIX} compiling deps
	@mix deps.compile 1>/dev/null
	@echo ${LOG_PREFIX} compiling
	@mix compile 1>/dev/null

cleandev:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/dev deps

cleanprod:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/prod deps

release: export MIX_ENV = prod
release: prod
	@echo ${LOG_PREFIX} creating release
	@mix release --env=prod

run:
	iex -S mix
