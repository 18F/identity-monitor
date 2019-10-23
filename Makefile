# Makefile for building and running the project.
# The purpose of this Makefile is to avoid developers having to remember
# project-specific commands for building, running, etc.  Recipes longer
# than one or two lines should live in script files of their own in the
# bin/ directory.

all: check

setup:
	bundle check || bundle install

check: setup lint test

lint: $(CONFIG)
	@echo "--- rubocop ---"
	rubocop
	@echo "--- reek ---"
	reek

test:
	bundle exec rspec --tag ~voice

build_nr_scripts:
	npm run build-nr-scripts

.PHONY: all lint test check
