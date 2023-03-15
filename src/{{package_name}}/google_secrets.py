import os
import re
import logging

import gcloud_config_helper
import google.auth
from google.cloud.secretmanager_v1 import SecretManagerServiceClient


class SecretName:
    """
    represents a Google Secret Manager secret version name. Provides for a human-readable
    version specification and returns a fully qualified name.

    >>> SecretName("my-secret", "playground")
    projects/playground/secrets/my-secret/versions/latest
    >>> SecretName("projects/playground/secrets/my-secret/versions/latest", "other-project")
    projects/playground/secrets/my-secret/versions/latest
    >>> SecretName("playground/my-secret/1", "other-project")
    projects/playground/secrets/my-secret/versions/1
    >>> SecretName("my-secret/2", "other-project")
    projects/other-project/secrets/my-secret/versions/2
    >>> SecretName("playground/my-secret/version/more", "project")
    Traceback (most recent call last):
    ...
    ValueError: expected 3 components in secret playground/my-secret/version/more, found 4.
    """

    def __init__(self, name: str, project_id: str):
        simplified_name = (
            name.replace("projects/", "")
            .replace("secrets/", "")
            .replace("versions/", "")
        )
        parts = simplified_name.split("/")
        if len(parts) == 1:
            self.project_id = project_id
            self.secret_id = parts[0]
            self.version = "latest"
        elif len(parts) == 2:
            if re.match(r"([0-9]+|latest)", parts[1]):
                self.project_id = project_id
                self.secret_id = parts[0]
                self.version = parts[1]
            else:
                self.project_id = parts[0]
                self.secret_id = parts[1]
                self.version = "latest"
        elif len(parts) == 3:
            self.project_id, self.secret_id, self.version = parts
        else:
            raise ValueError(
                f"expected 3 components in secret {simplified_name}, found {len(parts)}."
            )

    def __repr__(self):
        return f"projects/{self.project_id}/secrets/{self.secret_id}/versions/{self.version}"


class SecretManager:
    def __init__(self, configuration: str = ""):
        if gcloud_config_helper.on_path():
            self.credentials = gcloud_config_helper.GCloudCredentials(configuration)
            self.project_id = self.credentials.project
        else:
            logging.info("using application default credentials")
            self.credentials, self.project_id = google.auth.default()

        self.client = SecretManagerServiceClient(credentials=self.credentials)

    def get_secret(self, name: str):
        """
        returns the data of the secret version `name`.
        """
        secret_name = SecretName(name, self.project_id)
        response = self.client.access_secret_version(name=str(secret_name))
        return response.payload.data.decode("utf-8")

    @staticmethod
    def get_instance(configuration: str = ""):
        global _INSTANCES
        if configuration not in _INSTANCES:
            _INSTANCES[configuration] = SecretManager(configuration)

        return _INSTANCES[configuration]


_INSTANCES: dict[str, SecretManager] = {}


def get_secret(name: str, configuration: str = ""):
    """
    gets the value of the secret `name` from the Google secret manager. you
    can override the value locally by setting the environment variable with  the
    name `name.upper().replace("-", "_")`

    For instance slackbot-app-token because SLACKBOT_APP_TOKEN.
    """
    env_name = name.upper().replace("-", "_")
    value = os.environ.get(env_name)
    return (
        value if value else SecretManager.get_instance(configuration).get_secret(name)
    )
