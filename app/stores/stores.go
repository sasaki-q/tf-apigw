package stores

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type Stores struct {
	MessageStore MessageStore
}

func NewStore() (*Stores, error) {
	cfg, err := config.LoadDefaultConfig(
		context.TODO(),
		config.WithRegion(fmt.Sprintf("%s", os.Getenv("DYNAMO_REGION"))),
		config.WithEndpointResolver(aws.EndpointResolverFunc(
			func(service, region string) (aws.Endpoint, error) {
				return aws.Endpoint{
						URL:           fmt.Sprintf("%s", os.Getenv("DYNAMO_HOST")),
						SigningRegion: fmt.Sprintf("%s", os.Getenv("DYNAMO_REGION")),
					},
					nil
			}),
		),
	)

	if err != nil {
		return nil, err
	}

	client := dynamodb.NewFromConfig(cfg, func(o *dynamodb.Options) {
		o.Credentials = credentials.NewStaticCredentialsProvider(
			fmt.Sprintf("%s", os.Getenv("AWS_ACCESS_KEY_ID")),
			fmt.Sprintf("%s", os.Getenv("AWS_SECRET_ACCESS_KEY")),
			"",
		)
	})

	if err != nil {
		return nil, err
	}

	return &Stores{MessageStore: MessageStore{Client: client}}, nil
}
