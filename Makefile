default: test dev

dev:
	go run main.go

lint: 
	golangci-lint run

test:
	go test ./...
