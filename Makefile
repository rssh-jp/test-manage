.DEFAULT_GOAL := help

.PHONY: help setup up down logs

help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## repos.txt に記載されたリポジトリを repos/ 以下にクローンする
	@bash tools/setup/setup.sh

up: ## BE/BFF/FE を Docker Compose で起動する
	docker compose -f docker-compose.dev.yml up --build -d

down: ## Docker Compose サービスを停止する
	docker compose -f docker-compose.dev.yml down

logs: ## Docker Compose ログを表示する
	docker compose -f docker-compose.dev.yml logs -f
