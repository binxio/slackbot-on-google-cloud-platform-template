# Slackbot copier template
This copier templates deploys a Slackbot into Google Cloud Platform!

## Getting started!
To create and deploy your bot, type:

```shell
$ pip install copier
$ copier https://github.com/binxio/slackbot-on-google-cloud-platform-template authority-scraper-slackbot
🎤 the human readable name of your slackbot
   authority scraper slackbot
🎤 a short description of the Slackbot
   chats about authority contributions
🎤 the name of the package
   authority_scraper_slackbot
🎤 Your full name?
   Mark van Holsteijn
🎤 Your email address?
   mark.vanholsteijn@xebia.com
🎤 the google project to deploy to
   speeltuin-mvanholsteijn
🎤 primary region to deploy the slackbot to
   europe-west4
🎤 the replica region for slackbot artifacts
   europe-west1
🎤 the artifact repository location to deploy the image to
   europe
🎤 name of the terraform state bucket
   speeltuin-mvanholsteijn-terraform-state

Copying from template version 0.0.0.post6.dev0+78d6734
    create  .
    create  terraform
    create  terraform/providers.tf
    create  terraform/user-data.yaml
    create  terraform/versions.tf
    create  terraform/.gitignore
    create  terraform/variables.tf
    create  terraform/pipeline.tf
    create  terraform/slackbot.tf
    create  Dockerfile.jinja
    create  cloudbuild
    create  cloudbuild/deploy.yaml
    create  cloudbuild/build.yaml
    create  Pipfile
    create  .copier-answers.yml
    create  .gitignore
    create  Pipfile.lock
    create  .gcloudignore
    create  src
    create  src/authority_scraper_slackbot
    create  src/authority_scraper_slackbot/__init__.py
    create  src/authority_scraper_slackbot/google_secrets.py
    create  src/authority_scraper_slackbot/__main__.py
    create  src/authority_scraper_slackbot/bot.py

 > Running task 1 of 2: [[ ! -d .git ]] && ( git init --initial-branch master && git add . && git commit -m 'initial import' && git remote add origin https://source.developers.google.com/p/speeltuin-mvanholsteijn/r/authority-scraper-slackbot && git tag 0.0.0) || exit 0
Initialized empty Git repository in /private/tmp/slb/.git/

$ cd /tmp/slb
$ umask 077
```
This will create the following source code directory:

```text
.
├── Dockerfile
├── LICENSE
├── Makefile
├── Makefile.mk
├── Pipfile
├── cloudbuild
│   ├── build.yaml
│   └── deploy.yaml
├── pyproject.toml
├── setup.cfg
├── tox.ini
├── src
│   └── authority_scraper_slackbot
│       ├── __init__.py
│       ├── __main__.py
│       ├── bot.py
│       ├── google_secrets.py
│       └── manifest.yaml
├── tests
│   ├── test_command_help.py
│   └── test_mention_help.py
├── terraform
│   ├── pipeline.tf
│   ├── providers.tf
│   ├── slackbot.tf
│   ├── user-data.yaml
│   ├── variables.tf
│   └── versions.tf
├── secrets
```

## Activate requires Google services
Before you deploy and run the application, you activate the required Google services:

```shell
$ make enable-services
```

### install into Slack
To install the bot as an application in Slack, goto https://api.slack.com/apps and create a new application from the manifest
generated in the source directory. Follow the wizard and install the app in the workspace.

### create the Terraform state bucket
To create the terraform state bucket to store the Terraform state in, type:

```shell
$ make state-bucket
```
### deploy the slack bot
To deploy the slack bot to Google Cloud Platform, type:

```shell
$ make state-bucket
$ cd terraform
$ terraform init
$ terraform apply
```

### deploy the secrets
To deploy the secrets of the slack bot into the respective Google Secrets, type:

```shell
$ make configure-secrets
```

### push to the repository
Now deploy your changes to the git repository. This will trigger a build of the container image
and a deployment of the newly created image using Google CloudBuild.

```shell
$ git push
```

Now, check the [Google Cloudbuild logs](https://console.cloud.google.com/cloud-build/builds).
once the build and deploy complete, your bot is ready to run.

## that is it!
You can now chat with your bot and change the implementation!