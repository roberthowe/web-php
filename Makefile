.EXPORT_ALL_VARIABLES:

HTTP_HOST:=localhost:8080

.PHONY: help
help: ## Displays this list of targets with descriptions
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: coding-standards
coding-standards: vendor ## Fixes code style issues with friendsofphp/php-cs-fixer
	vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.php --diff --verbose

.PHONY: tests
tests: vendor ## Runs tests
	tests/server start; php tests/run-tests.php -j3 -q; tests/server stop

vendor: composer.json composer.lock
	composer validate --strict
	composer install --no-interaction --no-progress
