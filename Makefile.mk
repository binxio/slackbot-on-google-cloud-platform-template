help:           ## Show this help.
		@egrep -h ':[^#]*##' $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/:[^#]*##/: ##/' -e 's/[ 	]*##[ 	]*/ /' | \
		awk -F: '{printf "%-20s -", $$1; $$1=""; print $$0}'

state-bucket:	## create the terraform state bucket
	gsutil mb -p $(GOOGLE_PROJECT) -l $(TERRAFORM_STATE_BUCKET_LOCATION) gs://$(TERRAFORM_STATE_BUCKET)
	gsutil versioning set on gs://$(TERRAFORM_STATE_BUCKET)

fmt:	## formats the source code
	black src/ tests/

test:	## run python unit tests
	pipenv run tox


Pipfile.lock: Pipfile setup.cfg pyproject.toml
	pipenv update -d

tag-patch-release: ## create a tag for a new patch release
	pipenv run git-release-tag bump --level patch

tag-minor-release: ## create a tag for a new minor release
	pipenv run git-release-tag bump --level minor

tag-major-release: ## create a tag for new major release
	pipenv run git-release-tag bump --level major

show-version: ## shows the current version of the workspace
	pipenv run git-release-tag show .

