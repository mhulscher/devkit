ifndef $(RELEASE)
RELEASE=$(shell git tag -l --points-at HEAD)
endif
COMMIT=git-$(shell git rev-parse --short HEAD)
ifndef $(APP)
APP=devkit
endif
REGISTRY=quay.io/mhulscher
REPOSITORY=$(REGISTRY)/$(APP)

all: docker-image
clean: docker-rmi

ci-build: docker-image docker-push write-version clean
ci-deploy: deis-deploy

create-artifact:

docker-image:
	docker build -t $(REPOSITORY):$(COMMIT) .
ifneq ($(RELEASE),)
	docker tag $(REPOSITORY):$(COMMIT) $(REPOSITORY):$(RELEASE)
endif

docker-push:
	docker push $(REPOSITORY):$(COMMIT)
ifneq ($(RELEASE),)
	docker push $(REPOSITORY):$(RELEASE)
endif

write-version:
ifneq ($(RELEASE),)
	echo release=$(RELEASE) > version.txt
else
	echo release=$(COMMIT)  > version.txt
endif


docker-rmi:
	docker rmi $(REPOSITORY):$(COMMIT)
ifneq ($(RELEASE),)
	docker rmi $(REPOSITORY):$(RELEASE)
endif

deis-deploy:
ifneq ($(RELEASE),)
	deis pull $(REPOSITORY):$(RELEASE) -a $(APP)
else
	deis pull $(REPOSITORY):$(COMMIT) -a $(APP)
endif
