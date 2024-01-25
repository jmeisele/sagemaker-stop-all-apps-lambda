import json
from typing import Any, Dict

import src
from src.handler import lambda_handler


def test_lambda_handler(monkeypatch) -> None:
    def mock_list_user_profiles(*args: str, **kwargs: str) -> Dict[str, Any]:
        return {
            "UserProfiles": [
                {
                    "DomainId": "test-domain",
                    "UserProfileName": "test-user",
                    "Status": "InService",
                },
            ],
            "NextToken": "string",
        }

    monkeypatch.setattr(
        src.handler.client, "list_user_profiles", mock_list_user_profiles
    )

    event = {"domain_id": "domain"}
    context = {}
    result = lambda_handler(event, context)
    expected = {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps("Hello from lambda"),
    }
    assert result == expected
