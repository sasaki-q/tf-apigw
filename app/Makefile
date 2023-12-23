.PHONY: build clean deploy deploy-local

build:
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/hc hc/main.go
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/message/create message/create/main.go
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/message/list message/list/main.go

clean:
	rm -rf ./bin ./vendor Gopkg.lock

deploy: clean build
	sls deploy --verbose

deploy-local: clean build
	sls offline --httpPort 8080 --lambdaPort 8081 --debug * --verbose

deploy-dynamo:
	sls dynamodb start
