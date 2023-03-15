SHELL = /bin/bash

help:           ## Show this help.
		@egrep -h ':[^#]*##' $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:[^#]*##/: ##/' -e 's/[ 	]*##[ 	]*/ /' | \
		awk -F: '{printf "%-20s -", $$1; $$1=""; print $$0}'

.PHONY: configure-secrets
configure-secrets: secrets/bot-token.upload secrets/app-token.upload secrets/signing-secret.upload ## configure Slackbot token and signing key

enable-services:  ## enable required services
	gcloud services enable $(GOOGLE_PROJECT_SERVICES)

secrets/bot-token.upload: secrets/bot-token
	gcloud secrets versions add $(SLACKBOT_NAME)-bot-token \
	    --data-file secrets/bot-token && \
	touch $@

secrets/app-token.upload: secrets/app-token
	gcloud secrets versions add $(SLACKBOT_NAME)-app-token \
	    --data-file secrets/app-token && \
	touch $@

secrets/signing-secret.upload: secrets/signing-secret
	gcloud secrets versions add $(SLACKBOT_NAME)-signing-secret \
	    --data-file secrets/signing-secret && \
	touch $@

secrets/bot-token:
	@read -s -p 'slackbot bot token:' SLACKBOT_BOT_TOKEN && \
	echo -n "$$SLACKBOT_BOT_TOKEN" > $@ && \
	chmod 0600 $@

secrets/app-token:
	@read -s -p 'slackbot app token:' SLACKBOT_APP_TOKEN && \
	echo -n "$$SLACKBOT_APP_TOKEN" > $@ && \
	chmod 0600 $@

secrets/signing-secret:
	@read -s -p 'slackbot signing secret:' SLACKBOT_SIGNING_SECRET && \
	echo -n "$$SLACKBOT_SIGNING_SECRET" > $@ \
	chmod 0600 $@

.PHONY: state-bucket
state-bucket:	## create the terraform state bucket
	gsutil mb -p $(GOOGLE_PROJECT) -l $(TERRAFORM_STATE_BUCKET_LOCATION) gs://$(TERRAFORM_STATE_BUCKET)
	gsutil versioning set on gs://$(TERRAFORM_STATE_BUCKET)

.PHONY: fmt
fmt:	## formats the source code
	black src/ tests/

.PHONY: test
test:	Pipfile.lock ## run python unit tests
	pipenv run tox

Pipfile.lock: Pipfile setup.cfg pyproject.toml
	pipenv update -d

.PHONY: tag-patch-release tag-minor-release tag-major-release
tag-patch-release: ## create a tag for a new patch release
	pipenv run git-release-tag bump --level patch

tag-minor-release: ## create a tag for a new minor release
	pipenv run git-release-tag bump --level minor

tag-major-release: ## create a tag for new major release
	pipenv run git-release-tag bump --level major

.PHONY: show-version
show-version: ## shows the current version of the workspace
	pipenv run git-release-tag show .

