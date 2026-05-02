.DEFAULT_GOAL := help

.PHONY: help setup

help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## repos.txt に記載されたリポジトリを repos/ 以下にクローンする
	@bash tools/setup/setup.sh
