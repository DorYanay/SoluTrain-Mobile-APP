SHELL:=/usr/bin/env bash -O globstar

# Clean the project from cache
clean:
	cd backend && make clean

fix:
	cd backend && make fix

lint:
	cd backend && make lint

# Run the formatters and linters
fix-lint: fix lint

migrate:
	cd backend && make migrate

start-db:
	docker-compose up db -d

start-backend:
	cd backend && make start
