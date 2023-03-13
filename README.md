# Slackbot copier template

This copier templates deploys a Slackbot into Google Cloud Platform!

## Getting started!
To deploy your bot, type:

### Create the source code repository
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
    create  Dockerfile
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
```

Now go to the target directory, and complete the readme.
