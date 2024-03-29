GIT_HASH := $(CIRCLE_SHA1)
ifeq ($(GIT_HASH),)
GIT_HASH := $(shell git rev-parse HEAD)
endif

DOCKER_REGISTRY?=registry.uw.systems
DOCKER_REPOSITORY_NAMESPACE?=onboarding
DOCKER_ID?=onboarding
DOCKER_REPOSITORY_IMAGE=onboarding-nsilva
DOCKER_REPOSITORY=$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY_NAMESPACE)/$(DOCKER_REPOSITORY_IMAGE)

default: test dev

dev:
	go run main.go

lint:
	golangci-lint run

test:
	go test ./...

install:
	go build -o bin/onboarding-nsilva

docker_build:
	docker build -t $(DOCKER_REPOSITORY):$(GIT_HASH) .
	docker tag $(DOCKER_REPOSITORY):$(GIT_HASH) $(DOCKER_REPOSITORY):latest

docker_login:
	echo $(UW_DOCKER_PASS) | docker login --username $(DOCKER_ID) --password-stdin $(DOCKER_REGISTRY)

docker_push:
	docker push $(DOCKER_REPOSITORY)

k8s_push:
	curl -X PATCH -k -d '{"spec":{"template":{"spec":{"containers":[{"name":"onboarding-nsilva","image":"$(DOCKER_REPOSITORY):$(GIT_HASH)"}]}}}}' \
		-H "Content-Type: application/strategic-merge-patch+json" \
		-H "Authorization: Bearer $(K8S_DEV_TOKEN)" \
		"https://elb.master.k8s.dev.uw.systems/apis/apps/v1/namespaces/onboarding/deployments/onboarding-nsilva"
