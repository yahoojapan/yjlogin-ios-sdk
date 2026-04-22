.PHONY: setup
setup:
	bash scripts/prepare.sh

.PHONY: docs
docs:
	bundle exec jazzy
