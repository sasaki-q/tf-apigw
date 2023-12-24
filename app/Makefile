.PHONY: build clean deploy deploy-local

build:
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/hc functions/hc/main.go
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/message/create functions/message/create/main.go
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o bin/message/list functions/message/list/main.go

clean:
	rm -rf ./bin ./vendor Gopkg.lock

deploy: clean build
	sls deploy --verbose

deploy-local: clean build
	sls offline start --httpPort 8080 --lambdaPort 8081 --dockerNetwork app_serverless --debug * --verbose --noTimeout
