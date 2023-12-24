package stores

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/sasaki-q/serverless-sample/models"
)

type MessageStore struct {
	Client *dynamodb.Client
}

var tableName = "messages"

func (s *MessageStore) ListMessage(
	ctx context.Context,
	userId string,
	createdAt string,
) (*[]models.Message, error) {
	var messages []models.Message

	k := "user_id = :p and begins_with(created_at, :r)"
	res, err := s.Client.Query(ctx, &dynamodb.QueryInput{
		TableName: &tableName,
		ExpressionAttributeValues: map[string]types.AttributeValue{
			":p": &types.AttributeValueMemberN{Value: userId},
			":r": &types.AttributeValueMemberS{Value: createdAt},
		},
		KeyConditionExpression: &k,
	})

	if err != nil {
		return nil, err
	}

	err = attributevalue.UnmarshalListOfMaps(res.Items, &messages)
	if err != nil {
		return nil, err
	}

	return &messages, nil
}

func (s *MessageStore) WriteMessage(
	ctx context.Context,
	item map[string]types.AttributeValue,
) (*dynamodb.PutItemOutput, error) {
	return s.Client.PutItem(ctx, &dynamodb.PutItemInput{TableName: &tableName, Item: item})
}
