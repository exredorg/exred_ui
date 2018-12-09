.PHONY: dev prod cleandev cleanprod compile release publish docs test run

DOCKERHUB_USER := zsolt001

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
APP_DIR := $(dir $(MKFILE_PATH))
APP_NAME := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
VERSION_FILE := $(dir $(MKFILE_PATH))/VERSION
VERSION := $(shell sed 's/^ *//;s/ *$$//' $(VERSION_FILE))

LOG_PREFIX = '>>> MAKE >>> ${APP_NAME} | ${MIX_ENV}:'
MAKE_DONE = '>>> MAKE DONE >>> $@'

# Define docker tags
#
# Images are tagged with app_name:{version}-{commit hash}
# and also as latest
# eg.: exred:1.2-df08cc, exred:latest
#
# Same scheme applies to docker hub tags except the image is also tagged with
# just the version without the git hash. 
# This gives us a unique tag for each build and a rolling version tag.
# eg.: zsolt001/exred:1.2-df08cc, zsolt001/exred:1.2 , zsolt001/exred:latest
GIT_HASH := $(shell git rev-parse --short HEAD)
IMAGE := $(APP_NAME):$(VERSION)-$(GIT_HASH)
LATEST := $(APP_NAME):latest
HUBTAG_VERSION := $(DOCKERHUB_USER)/$(APP_NAME):$(VERSION)
HUBTAG_UNIQUE := $(DOCKERHUB_USER)/$(IMAGE)
HUBTAG_LATEST := $(DOCKERHUB_USER)/$(LATEST)

RPI_IMAGE := $(APP_NAME)_rpi:$(VERSION)-$(GIT_HASH)
RPI_LATEST := $(APP_NAME)_rpi:latest
RPI_HUBTAG_VERSION := $(DOCKERHUB_USER)/$(APP_NAME)_rpi:$(VERSION)
RPI_HUBTAG_UNIQUE := $(DOCKERHUB_USER)/$(RPI_IMAGE)
RPI_HUBTAG_LATEST := $(DOCKERHUB_USER)/$(RPI_LATEST)


dev: export MIX_ENV = dev
dev: compile
	@echo $(MAKE_DONE)

prod: export MIX_ENV = prod
prod: git-status-test cleanprod compile
	@echo $(MAKE_DONE)

compile:
	@echo ${LOG_PREFIX} getting deps
	@mix deps.get 1>/dev/null
	@echo ${LOG_PREFIX} compiling deps
	@mix deps.compile 1>/dev/null
	@echo ${LOG_PREFIX} compiling application
	@mix compile 
	@echo $(MAKE_DONE)

cleandev: export MIX_ENV = dev
cleandev:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/dev deps
	@echo $(MAKE_DONE)

cleanprod: export MIX_ENV = prod
cleanprod:
	@echo ${LOG_PREFIX} cleaning
	@rm -rf _build/prod deps
	@echo $(MAKE_DONE)

release: export MIX_ENV = prod
release: prod
	@echo ${LOG_PREFIX} creating release
	@mix release --env=prod
	@echo $(MAKE_DONE)

docker.build: git-status-test
	@echo ${LOG_PREFIX} building image $(IMAGE) with context $(APP_DIR)
	@docker build -t $(IMAGE) -f $(APP_DIR)/docker/Dockerfile.x86 $(APP_DIR) --build-arg VERSION=$(VERSION)
	@docker tag $(IMAGE) $(LATEST)
	@echo $(MAKE_DONE)

rpi-docker.build: git-status-test
	@echo ${LOG_PREFIX} building image $(RPI_IMAGE) with context $(APP_DIR)
	@docker build -t $(RPI_IMAGE) -f $(APP_DIR)/docker/Dockerfile.rpi $(APP_DIR) --build-arg VERSION=$(VERSION)
	@docker tag $(RPI_IMAGE) $(RPI_LATEST)
	@echo $(MAKE_DONE)

docker.publish: docker.build
	@echo ${LOG_PREFIX} tagging git repo with current version: $(VERSION)
	@git tag -a "v$(VERSION)" -m "version $(VERSION)" || echo "${LOG_PREFIX} WARNING git tag for this version already exists" 
	@echo ${LOG_PREFIX} pushing repository to origin
	@git push 
	@echo ${LOG_PREFIX} pushing git tag to origin
	@git push origin "v$(VERSION)"
	@echo ${LOG_PREFIX} tagging docker image with $(HUBTAG_VERSION)
	@docker tag $(IMAGE) $(HUBTAG_UNIQUE)
	@docker tag $(IMAGE) $(HUBTAG_VERSION)
	@docker tag $(IMAGE) $(HUBTAG_LATEST)
	@echo ${LOG_PREFIX} publishing to Docker Hub
	docker push $(HUBTAG_UNIQUE)
	docker push $(HUBTAG_VERSION)
	docker push $(HUBTAG_LATEST)
	@echo $(MAKE_DONE)

rpi-docker.publish: rpi-docker.build
	@echo ${LOG_PREFIX} tagging git repo with current version: $(VERSION)
	@git tag -a "v$(VERSION)" -m "version $(VERSION)" || echo "${LOG_PREFIX} WARNING git tag for this version already exists" 
	@echo ${LOG_PREFIX} pushing repository to origin
	@git push 
	@echo ${LOG_PREFIX} pushing git tag to origin
	@git push origin "v$(VERSION)"
	@echo ${LOG_PREFIX} tagging docker image with $(RPI_HUBTAG_VERSION)
	@docker tag $(RPI_IMAGE) $(RPI_HUBTAG_UNIQUE)
	@docker tag $(RPI_IMAGE) $(RPI_HUBTAG_VERSION)
	@docker tag $(RPI_IMAGE) $(RPI_HUBTAG_LATEST)
	@echo ${LOG_PREFIX} publishing to Docker Hub
	docker push $(RPI_HUBTAG_UNIQUE)
	docker push $(RPI_HUBTAG_VERSION)
	docker push $(RPI_HUBTAG_LATEST)
	@echo $(MAKE_DONE)

docs: git-status-test
	@echo ${LOG_PREFIX} updating documentation
	@mix docs 1>/dev/null
	@echo $(MAKE_DONE)

run:
	iex -S mix phx.server

test:
	@echo ${LOG_PREFIX} running tests
	@mix test
	@echo $(MAKE_DONE)

git-status-test:
	@test -z "$(shell git status -s 2>&1)" \
          && echo "Git repo is clean" \
          || (echo "Failed: uncommitted changes in git repo" && exit 1)

rpi-docker-pre-build:
	docker run --rm --privileged multiarch/qemu-user-static:register # --reset