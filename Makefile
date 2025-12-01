# Variables
MODE ?= dev
ifeq ($(MODE), prod)
	COMPOSE_FILE := docker/compose.production.yaml
else
	COMPOSE_FILE := docker/compose.development.yaml
endif

# Service Defaults
SERVICE ?= backend


# Docker Services


up:
	@echo "Starting services in $(MODE) mode..."
	docker-compose -f $(COMPOSE_FILE) up -d $(ARGS)

down:
	@echo "Stopping services..."
	docker-compose -f $(COMPOSE_FILE) down $(ARGS)

build:
	@echo "Building services..."
	docker-compose -f $(COMPOSE_FILE) build $(ARGS)

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f $(SERVICE)

restart:
	@echo "Restarting services..."
	docker-compose -f $(COMPOSE_FILE) restart $(ARGS)

shell:
	docker-compose -f $(COMPOSE_FILE) exec $(SERVICE) sh

ps:
	docker-compose -f $(COMPOSE_FILE) ps

# Convenience Aliases (Development)


dev-up:
	@make up MODE=dev ARGS="--build"

dev-down:
	@make down MODE=dev

dev-build:
	@make build MODE=dev

dev-logs:
	@make logs MODE=dev

dev-restart:
	@make restart MODE=dev

dev-shell:
	@make shell MODE=dev SERVICE=backend

dev-ps:
	@make ps MODE=dev

backend-shell:
	@make shell SERVICE=backend

gateway-shell:
	@make shell SERVICE=gateway

mongo-shell:
	docker-compose -f $(COMPOSE_FILE) exec mongo mongosh -u root -p example


# Convenience Aliases (Production)


prod-up:
	@make up MODE=prod

prod-down:
	@make down MODE=prod

prod-build:
	@make build MODE=prod

prod-logs:
	@make logs MODE=prod

prod-restart:
	@make restart MODE=prod

# Backend Local Utilities


backend-build:
	cd backend && npm run build

backend-install:
	cd backend && npm install

backend-type-check:
	cd backend && npx tsc --noEmit

backend-dev:
	cd backend && npm run dev


# Database


db-reset:
	@echo "WARNING: Deleting all data in MongoDB..."
	docker-compose -f $(COMPOSE_FILE) down -v
	docker-compose -f $(COMPOSE_FILE) up -d mongo

db-backup:
	@echo "Creating backup..."
	docker-compose -f $(COMPOSE_FILE) exec mongo mongodump --out /data/db/backup


# Cleanup


clean:
	docker-compose -f docker/compose.development.yaml down --remove-orphans
	docker-compose -f docker/compose.production.yaml down --remove-orphans

clean-all:
	docker system prune -af --volumes

clean-volumes:
	docker volume prune -f

# Utilities


status: ps

health:
	@echo "Checking Gateway Health..."
	curl http://localhost:5921/health

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Examples:"
	@echo "  make dev-up        Start development environment"
	@echo "  make dev-down      Stop development environment"
	@echo "  make logs          View backend logs"
	@echo "  make shell         Open shell in backend container"