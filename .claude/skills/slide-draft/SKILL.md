---
name: slide-draft
description: |
  context/ の情報をもとに slides.md を執筆するスキル。
  TRIGGER when: 「スライドを書いて」「slides.md を作って」「アウトラインからスライドに起こして」など、スライド本文の執筆を依頼された場合。
  DO NOT TRIGGER when: アウトライン・台本の作成のみ。スライドのレビュー。新規発表のセットアップ。
---

# slide-draft

`context/01-brief.md`, `02-raw-notes.md`, `03-outline.md` を読み `slides.md` を執筆する。

## 事前確認

執筆前に以下を読む：

- `context/01-brief.md` — 発表前提・想定聴衆・一番伝えたいこと
- `context/02-raw-notes.md` — 素材・参考情報
- `context/03-outline.md` — スライド構成
- `docs/rule-slide.md` — スライドの書き方ルール（Frontmatter・クラス・順序など）

## 執筆後

`make build-image`, `make build-pdf`, `make dev`でレイアウト確認することをユーザーに案内する。
