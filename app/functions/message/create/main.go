package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/sasaki-q/serverless-sample/handler"
)

func main() {
	h := handler.NewHandler()
	lambda.Start(h.CreateMessage)
}
