package handler

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/sasaki-q/serverless-sample/models"
	"github.com/sasaki-q/serverless-sample/stores"
	"github.com/sasaki-q/serverless-sample/utils"
)

type Handler struct {
	Stores stores.Stores
}

func NewHandler() Handler {
	s, err := stores.NewStore()
	if err != nil {
		panic("cannot establish connection")
	}
	return Handler{Stores: *s}
}

func (h *Handler) ListMessage(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	userId, ok := req.QueryStringParameters["user_id"]
	if !ok {
		return errorResponse(400, errors.New("Query parameter is missing."))
	}

	_, err := strconv.Atoi(userId)
	if err != nil {
		return errorResponse(400, err)
	}

	res, err := h.Stores.MessageStore.ListMessage(ctx, userId, "2023")
	if err != nil {
		return errorResponse(500, err)
	}

	return response(res)
}

type CreateMessageSchema struct {
	UserId  int    `json:"user_id"`
	Message string `json:"message"`
}

func (h *Handler) CreateMessage(ctx context.Context, req events.APIGatewayProxyRequest) (Response, error) {
	var rb CreateMessageSchema
	err := json.Unmarshal([]byte(req.Body), &rb)
	if err != nil {
		return errorResponse(400, err)
	}

	messageObj := &models.Message{
		UserId:    rb.UserId,
		Message:   rb.Message,
		CreatedAt: utils.CurrentTimestamp(),
	}
	messageItem, err := attributevalue.MarshalMap(*messageObj)
	if err != nil {
		return errorResponse(400, err)
	}

	_, err = h.Stores.MessageStore.WriteMessage(ctx, messageItem)
	if err != nil {
		return errorResponse(500, err)
	}

	return response(messageObj)
}
