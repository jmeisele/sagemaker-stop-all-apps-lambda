import json
from typing import Any, Dict

import src
from src.handler import lambda_handler


def test_lambda_handler(monkeypatch) -> None:
    def mock_list_apps(*args: str, **kwargs: str) -> Dict[str, Any]:
        return {
            "Apps": [
                {
                    "DomainId": 'test-domain"',
                    "UserProfileName": "test-user",
                    "AppType": "JupyterServer",
                    "AppName": "my-app",
                    "Status": "InService",
                    "SpaceName": "test-space",
                },
            ],
            "NextToken": "string",
        }

    def mock_delete_app(*args: str, **kwargs: str) -> None:
        return None

    monkeypatch.setattr(src.handler.client, "list_apps", mock_list_apps)
    monkeypatch.setattr(src.handler.client, "delete_app", mock_delete_app)

    event = {"domain_id": "domain"}
    context = {}
    result = lambda_handler(event, context)
    expected = {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps("Hello from lambda"),
    }
    assert result == expected
