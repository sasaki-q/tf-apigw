package models

type Message struct {
	UserId    int    `json:"user_id" dynamodbav:"user_id"`
	Message   string `json:"title" dynamodbav:"message"`
	CreatedAt string `json:"created_at" dynamodbav:"created_at"`
}
