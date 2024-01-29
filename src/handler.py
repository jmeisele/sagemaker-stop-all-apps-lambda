import json
from typing import Any, Dict

import boto3

client = boto3.client("sagemaker")


def lambda_handler(event: Dict, context: Dict) -> Dict[str, Any]:
    print(f"Event: {event}:")
    print(f"Context: {context}:")

    list_apps_response = client.list_apps(DomainIdEquals=event["domain_id"])
    print(f"list_apps_response: {list_apps_response}")

    for app in list_apps_response["Apps"]:
        print(f"app: {app}")
        if app["Status"] != "Deleted" or app["Status"] != "Failed":
            client.delete_app(
                DomainId=event["domain_id"], AppType=app["AppType"], AppName=app["AppName"], SpaceName=app["SpaceName"]
            )

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps("Hello from lambda"),
    }
