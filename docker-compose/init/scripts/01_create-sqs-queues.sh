#!/bin/bash
echo "########### Setting up localstack profile ###########"
aws configure set aws_access_key_id access_key --profile=localstack
aws configure set aws_secret_access_key secret_key --profile=localstack
aws configure set region sa-east-1 --profile=localstack

echo "########### Setting default profile ###########"
export AWS_DEFAULT_PROFILE=localstack

echo "########### Setting SQS names as env variables ###########"
export TEST_SQS=Test-SQS

echo "########### Creating queues ###########"
aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name $TEST_SQS

echo "########### Listing queues ###########"
aws --endpoint-url=http://localhost:4566 sqs list-queues

echo "########### Putting one message to the queue ###########"
aws --endpoint-url=http://localhost:4566 sqs send-message --queue-url=http://localhost:4566/000000000000/$TEST_SQS \
    --message-body={'{"id": "266fbb42-aee6-4402-a965-e55f5273c142",
                      "fullName": "Lisandra Wisozk",
                      "phoneNumber": "(591) 909-5191",
                      "address": "Suite 011 37845 Kub Flat, Trompmouth, WY 29493",
                      "createdAt": "2015-10-06",
                      "purchaseTransactions": [
                              {
                              "id": "96db4816-7f40-43e5-ba63-573730e73e1f",
                              "paymentType": "JCB",
                              "amount": 60.47,
                              "createdAt": "2017-07-01"
                                }
                              ]}'}

echo "########### Putting message to the queue form file ###########"
aws --endpoint-url=http://localhost:4566 sqs send-message --queue-url=http://localhost:4566/000000000000/$TEST_SQS --message-body=file:///tmp/localstack/data/sqs-messages/single-message.json

echo "########### Putting  message to the queue in batch ###########"
aws --endpoint-url=http://localhost:4566 sqs send-message-batch \
    --queue-url =http://localhost:4566/000000000000/$TEST_SQS \
    --entries "[{\"Id\":\"Batch-1\",\"MessageBody\":\"{\\\"id\\\":\\\"7bc5ab98-126a-4cbd-abd3-2eb8aa9f933c\\\",\\\"fullName\\\":\\\"Carroll Vandervort DVM\\\",\\\"phoneNumber\\\":\\\"649.164.8459\\\",\\\"address\\\":\\\"6750 Kreiger Islands, Port Wilbertside, GA 60013\\\",\\\"createdAt\\\":\\\"2016-02-01\\\",\\\"purchaseTransactions\\\":[{\\\"id\\\":\\\"75770e5d-c763-4806-a3cc-ae9498857128\\\",\\\"paymentType\\\":\\\"FORBRUGSFORENINGEN\\\",\\\"amount\\\":39.63,\\\"createdAt\\\":\\\"2018-12-10\\\"}]}\"},{\"Id\":\"Batch-2\",\"MessageBody\":\"{\\\"id\\\":\\\"34c8d1db-46e0-4a80-bc0c-864de3db0047\\\",\\\"fullName\\\":\\\"Jamison Lindgren I\\\",\\\"phoneNumber\\\":\\\"890.768.1341\\\",\\\"address\\\":\\\"86913 Rocky Center, South Dwanatown, OH 22960-2683\\\",\\\"createdAt\\\":\\\"2021-03-09\\\",\\\"purchaseTransactions\\\":[{\\\"id\\\":\\\"7eac12b1-f4ab-4f03-b4fe-bb9ea7e61127\\\",\\\"paymentType\\\":\\\"LASER\\\",\\\"amount\\\":32.32,\\\"createdAt\\\":\\\"2014-12-17\\\"}]}\"}]"


echo "########### Putting  message to the queue in batch from file ###########"
aws --endpoint-url=http://localhost:4566 sqs send-message-batch --queue-url =http://localhost:4566/000000000000/$TEST_SQS --entries file:///tmp/localstack/data/sqs-messages/batch-message.json
