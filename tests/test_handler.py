import json

from src.handler import lambda_handler


def test_lambda_handler(sagemaker_client) -> None:
    event = {"domain_id": "domain"}
    context = {}
    result = lambda_handler(event, context)
    expected = {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps("Hello from lambda"),
    }
    assert result == expected
