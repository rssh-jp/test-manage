# test-manage

BE（バックエンド）・BFF（Backend for Frontend）・FE（フロントエンド）関連リポジトリを一元管理するモノレポです。  
A monorepo for managing BE (Backend), BFF (Backend for Frontend), and FE (Frontend) related repositories.

---

## ディレクトリ構成 / Directory Layout

```
test-manage/
├── tools/      … セットアップスクリプトおよびユーティリティ / Setup scripts and utilities
├── repos/      … クローンされたリポジトリ（tools/setup/setup.sh により管理）/ Cloned repositories (managed by tools/setup/setup.sh)
├── docs/       … ドキュメント / Documentation
├── tools/setup/repos.txt   … 管理対象リポジトリのURL一覧 / List of repository URLs to manage
└── Makefile    … タスクランナー / Task runner
```

---

## 使い方 / How to Use

### セットアップ / Setup

`tools/setup/repos.txt` に記載されたすべてのリポジトリを `repos/` 以下にクローンします。  
Clones all repositories listed in `tools/setup/repos.txt` into the `repos/` directory.

```bash
make setup
```

---

## tools/setup/repos.txt の書式 / repos.txt Format

- 1行につき1リポジトリの URL を記載します。  
  One repository URL per line.
- `#` で始まる行はコメントとして無視されます。  
  Lines starting with `#` are treated as comments and ignored.
- 空行も無視されます。  
  Blank lines are also ignored.

**例 / Example:**

```
# https://github.com/your-org/backend.git
# https://github.com/your-org/bff.git
# https://github.com/your-org/frontend.git
```
