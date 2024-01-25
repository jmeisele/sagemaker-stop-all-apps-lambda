import json
from typing import Any, Dict

import boto3

client = boto3.client("sagemaker")


def lambda_handler(event: Dict, context: Dict) -> Dict[str, Any]:
    print(f"Event: {event}:")
    print(f"Context: {context}:")

    user_profile_response = client.list_user_profiles(DomainIdEquals=event["domain_id"])
    print(f"user_profile_response: {user_profile_response}")

    user_profiles = [
        x["UserProfileName"] for x in user_profile_response["UserProfiles"]
    ]
    print(f"user_profiles: {user_profiles}")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps("Hello from lambda"),
    }
