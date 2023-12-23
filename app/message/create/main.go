package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type CreateMessageSchema struct {
	UserId  int    `json:"user_id"`
	Message string `json:"message"`
}

type Response events.APIGatewayProxyResponse

func CreateMessageHandler(_ context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	var rb CreateMessageSchema
	err := json.Unmarshal([]byte(req.Body), &rb)
	if err != nil {
		return Response{StatusCode: 400}, err
	}

	resp := Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Body:            fmt.Sprintf("DEBUG: request body === %#v", rb),
		Headers: map[string]string{
			"Content-Type":           "application/json",
			"X-MyCompany-Func-Reply": "hello-handler",
		},
	}

	return resp, nil
}

func main() {
	lambda.Start(CreateMessageHandler)
}
