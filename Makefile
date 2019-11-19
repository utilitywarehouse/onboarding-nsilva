GIT_HASH := $(CIRCLE_SHA1)
ifeq ($(GIT_HASH),)
GIT_HASH := $(shell git rev-parse HEAD)
endif

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
	docker build -t onboarding-nsilva:$(GIT_HASH) .
	docker tag onboarding-nsilva:$(GIT_HASH) onboarding-nsilva:latest
