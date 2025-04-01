.PHONY: help commit cover format lint tests run postgres-setup populate-db run-db-queries

.DEFAULT: help

SHELL := /bin/bash
ENV = poetry run
PYTHON = $(ENV) python

MYPY = mypy
SOURCES = ./src
PYTEST = pytest --cache-clear
PYLINT = pylint --rcfile=./.pylintrc --fail-under=9.8

help: ## display commands help.
	@grep -E '^[a-zA-Z_-]+:.?## .$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

mac-setup: ## prepare development environment, use only once.
	@echo "       prepare development environment, use only once. It will install poetry, pyenv and the libraries"
	brew install poetry
	brew install pyenv
	brew install cmake
	brew install libomp
	brew install gcc
	make postgres-setup

postgres-setup: ## Install and configure PostgreSQL
	@echo "       Installing PostgreSQL via Homebrew"
	brew install postgresql@15
	brew services start postgresql@15
	@echo "       Verifying PostgreSQL connection"
	psql -d postgres -c "SELECT version();"
	@echo "       PostgreSQL setup complete"

populate-db: ## Populate database with SQL dump
	@echo "       Creating database for project"
	createdb tech_test
	@echo "       Populating database with SQL dump"
	psql -d tech_test -f src_sql_test/sql_tech_test.sql
	@echo "       Verifying data import"
	psql -d tech_test -c "SELECT COUNT(*) FROM tv_show;"
	psql -d tech_test -c "SELECT COUNT(*) FROM episode_sample;"
	@echo "       Database population complete"

run-db-queries: ## Run database query runner script
	@echo "       Running database queries"
	$(PYTHON) src_sql_test/db_query_runner.py

install:
	@echo "       install all dependencies"
	poetry install
	make install-git-hooks

install-git-hooks:
	poetry add --group dev pre-commit
	$(ENV) pre-commit install
	$(ENV) pre-commit install --hook-type commit-msg

format: ## run black to format all Python code.
	@echo "       run black to format all Python code"
	$(ENV) black .

commit: ## commit changes using citizen.
	@echo "       commit changes using citizen"
	$(ENV) cz commit

pre-commit:
	$(ENV) pre-commit run --all-files

lint: ## run linter.
	@echo "       run linter"
	$(ENV) $(PYLINT) $(SOURCES)

type-check: ## run type-checker.
	@echo "       run type-checker"
	$(ENV) $(MYPY) $(SOURCES)