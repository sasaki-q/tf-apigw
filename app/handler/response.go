package handler

import (
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
)

type Response events.APIGatewayProxyResponse

func response(obj interface{}) (Response, error) {
	marshalled, err := json.Marshal(map[string]interface{}{
		"message": "success",
		"detail":  obj,
	})
	if err != nil {
		return errorResponse(400, err)
	}

	return Response{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body:            string(marshalled),
		IsBase64Encoded: false,
	}, nil
}

func errorResponse(code int, err error) (Response, error) {
	return Response{
		StatusCode: code,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body:            err.Error(),
		IsBase64Encoded: false,
	}, err
}
