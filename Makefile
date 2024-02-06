SHELL:=/usr/bin/env bash -O globstar

# Clean the project from cache
clean:
	cd backend && make clean

fix:
	cd backend && make fix
	cd mobile && make fix

lint:
	cd backend && make lint
	cd mobile && make lint

# Run the formatters and linters
fix-lint: fix lint

migrate:
	cd backend && make migrate

rebuild-db:
	docker-compose rm -f -s db
	docker-compose up -d db
	sleep 1
	cd backend && make migrate

start-db:
	docker-compose up db -d

start-backend:
	cd backend && make start
