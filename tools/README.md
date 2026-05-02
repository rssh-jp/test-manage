# tools

このディレクトリにはリポジトリ管理のためのユーティリティスクリプトが含まれています。  
This directory contains utility scripts for repository management.

---

## ツール一覧 / Tool List

| ディレクトリ / Directory | スクリプト / Script | 概要 / Description                                                                                           | make コマンド / Make Command |
|--------------------------|---------------------|--------------------------------------------------------------------------------------------------------------|------------------------------|
| `setup/`                 | `setup.sh`          | `repos.txt` に記載された URL のリポジトリを `repos/` 以下にクローンし、完了後に全リポジトリのステータスを表示 | `make setup`                 |

---

## 各ツールの詳細 / Tool Details

### setup

```bash
make setup
```

`tools/setup/repos.txt` に記載された URL を読み込み、`repos/` ディレクトリ以下にリポジトリをクローンします。  
すでに存在するリポジトリはスキップされます。  
クローン完了後、すべてのリポジトリのブランチと `git status` を自動で表示します。
