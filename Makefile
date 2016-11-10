ifndef $(RELEASE)
RELEASE=$(shell git tag -l --points-at HEAD)
endif
COMMIT=git-$(shell git rev-parse --short HEAD)
ifndef $(APP)
APP=devkit
endif
REGISTRY=eu.gcr.io/sysops-1372
REPOSITORY=$(REGISTRY)/$(APP)

all: docker-image
clean: docker-rmi

ci-build: docker-image docker-push write-version docker-rmi

create-artifact:

docker-image:
	docker build -t $(REPOSITORY):$(COMMIT) .
	docker tag $(REPOSITORY):$(COMMIT) $(REPOSITORY):latest
ifneq ($(RELEASE),)
	docker tag $(REPOSITORY):$(COMMIT) $(REPOSITORY):$(RELEASE)
endif

docker-push:
	docker push $(REPOSITORY):$(COMMIT)
	docker push $(REPOSITORY):latest
ifneq ($(RELEASE),)
	docker push $(REPOSITORY):$(RELEASE)
endif

write-version:
ifneq ($(RELEASE),)
	echo release=$(RELEASE) > ci-vars.txt
else
	echo release=$(COMMIT)  > ci-vars.txt
endif

docker-rmi:
	docker rmi $(REPOSITORY):$(COMMIT)
	docker rmi $(REPOSITORY):latest
ifneq ($(RELEASE),)
	docker rmi $(REPOSITORY):$(RELEASE)
endif
