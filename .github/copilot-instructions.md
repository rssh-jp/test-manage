# Copilot Instructions

## プロジェクト概要

- このリポジトリはモノレポ管理用で、実装本体は `repos/` 配下の各サービスにある。
- 対象サービスは以下。
  - `repos/test-manage-be`: Go 製 BE（HTTP + gRPC、MySQL、クリーンアーキテクチャ）
  - `repos/test-manage-bff`: TypeScript + Fastify 製 BFF
  - `repos/test-manage-fe`: React + TypeScript + Vite 製 FE
- まず「どのサービスを変更するか」を明確にし、不要な横断変更を避ける。

## 共通ルール

- 変更は最小単位で行い、既存の責務分離・命名・構成を崩さない。
- 生成コードは手修正しない。仕様変更時は必ず生成コマンドで再生成する。
- 依存サービスに影響する変更をしたら、BFF/FE まで契約整合を確認する。
- 可能な限り対象サービスのローカル検証コマンドを実行してから完了とする。

## ディレクトリごとの実装方針

### repos/test-manage-be

- 既存方針に従い、依存方向は `interface -> usecase -> domain` を維持する。
- 永続化の実装は `src/infrastructure` に閉じ込める。
- リクエスト/レスポンス仕様を追加・変更する場合は以下を必須で更新する。
  - `proto/user/user.proto`
  - `api/openapi.yaml`
- 仕様更新後は `make gen` を実行し、`proto-gen` と `api-gen` の生成物を同期する。
- 生成物（例: `gen/api`, `proto/user/*.pb.go`）は手修正しない。
- 変更後は少なくとも `go test ./...` を実行して整合性を確認する。
- HTTP レスポンス、OpenAPI schema、gRPC message の意味を一致させる。

### repos/test-manage-bff

- BFF は FE 向けの API 境界として実装し、BE の内部都合をそのまま公開しない。
- FE 向けレスポンス構造を変える場合は、BE 契約差分と FE 型定義の双方を確認する。
- 主な検証コマンド。
  - `npm run build`
  - 必要に応じて `npm run dev` で疎通確認

### repos/test-manage-fe

- API 呼び出し仕様の変更時は `src/types.ts` と `src/api.ts` の整合を優先する。
- BFF のレスポンス変更がある場合、画面表示とフォーム更新処理への影響を確認する。
- 主な検証コマンド。
  - `npm run build`
  - 必要に応じて `npm run dev` で画面確認

## モノレポ運用コマンド

- 全体起動: `make up`
- 全体停止: `make down`
- 全体ログ: `make logs`

## 変更時チェックリスト

- 変更対象サービスが明確で、不要な他サービス変更を含んでいない。
- 仕様変更がある場合、BE の proto/OpenAPI/生成物が同期されている。
- BFF/FE の型・レスポンス変換・表示が契約変更に追従している。
- 対象サービスのビルドまたはテストが通っている。
