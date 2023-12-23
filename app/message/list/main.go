package main

import (
	"context"
	"errors"
	"fmt"
	"strconv"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response events.APIGatewayProxyResponse

func ListMessageHandler(_ context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	qp := req.QueryStringParameters["user_id"]
	if qp == "" {
		return Response{StatusCode: 400}, errors.New("Query parameter is missing.")
	}

	userId, err := strconv.Atoi(qp)
	if err != nil {
		return Response{StatusCode: 400}, err
	}

	resp := Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Body:            fmt.Sprintf("User ID: %d", userId),
		Headers: map[string]string{
			"Content-Type":           "application/json",
			"X-MyCompany-Func-Reply": "hello-handler",
		},
	}

	return resp, nil
}

func main() {
	lambda.Start(ListMessageHandler)
}
