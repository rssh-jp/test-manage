.DEFAULT_GOAL := help

.PHONY: help setup gen-certs k8s-apply k8s-delete up down logs sync-pq

help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## repos.txt に記載されたリポジトリを repos/ 以下にクローンする
	@bash tools/setup/setup.sh

gen-certs: ## 自己署名証明書を certs/ に生成する（localhost / 127.0.0.1 対応）
	@mkdir -p certs
	@openssl req -x509 -newkey rsa:4096 \
		-keyout certs/server.key \
		-out certs/server.crt \
		-days 365 -nodes \
		-subj '/CN=localhost' \
		-addext 'subjectAltName=DNS:localhost,IP:127.0.0.1'
	@echo "証明書を certs/ に生成しました"

k8s-apply: ## Traefik IngressRoute を k8s に適用する（https://localhost/ を有効化）
	kubectl apply -f k8s/

k8s-delete: ## Traefik IngressRoute を k8s から削除する
	kubectl delete -f k8s/

up: ## BE/BFF/FE を Docker Compose で起動する（証明書がない場合は自動生成）
	@if [ ! -f certs/server.crt ]; then $(MAKE) gen-certs; fi
	docker compose -f docker-compose.dev.yml up --build -d

down: ## Docker Compose サービスを停止する
	docker compose -f docker-compose.dev.yml down

logs: ## Docker Compose ログを表示する
	docker compose -f docker-compose.dev.yml logs -f

sync-pq: ## FE で codegen を実行し、生成した persisted-documents.json を BFF に登録する
	docker compose -f docker-compose.dev.yml exec fe npm run codegen
	cp repos/test-manage-fe/src/graphql/__generated__/persisted-documents.json \
	   repos/test-manage-bff/src/persisted-documents.json
	@echo "persisted-documents.json を BFF に登録しました"
