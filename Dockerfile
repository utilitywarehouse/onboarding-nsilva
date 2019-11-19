FROM golang:1.13-alpine AS builder

RUN apk update && apk upgrade && \
    apk add git make build-base

WORKDIR /build_area

COPY *.go Makefile ./

RUN wget -O - -q https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sh -s -- -b $(go env GOPATH)/bin v1.21.0
RUN make lint
RUN make test
RUN make install

FROM alpine:latest
COPY --from=builder /build_area/bin/onboarding-nsilva /bin/app
CMD ["/bin/app"]