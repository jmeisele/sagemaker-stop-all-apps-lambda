import datetime
import os

import boto3
import botocore
import pytest

os.environ["AWS_ACCESS_KEY_ID"] = "testing"
os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
os.environ["AWS_SECURITY_TOKEN"] = "testing"
os.environ["AWS_SESSION_TOKEN"] = "testing"
os.environ["AWS_DEFAULT_REGION"] = "us-east-1"


@pytest.fixture
def sagemaker_client(monkeypatch):
    """Sagemaker mock client"""

    def mock_list_user_profiles(self, operation_name, kwarg):
        return {
            'UserProfiles': [
                {
                    'DomainId': 'domain',
                    'UserProfileName': 'test-user',
                    'Status': 'InService',
                },
            ],
            'NextToken': 'string'
        }

    client = boto3.client("sagemaker")
    monkeypatch.setattr(
        botocore.client.BaseClient, "_make_api_call", mock_list_user_profiles
    )
    yield client
