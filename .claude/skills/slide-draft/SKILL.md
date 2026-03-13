---
name: slide-draft
description: |
  context/ の情報をもとに slides.md を執筆するスキル。
  TRIGGER when: 「スライドを書いて」「slides.md を作って」「アウトラインからスライドに起こして」など、スライド本文の執筆を依頼された場合。
  DO NOT TRIGGER when: アウトライン・台本の作成のみ。スライドのレビュー。新規発表のセットアップ。
---

# slide-draft

`context/01-brief.md`, `02-raw-notes.md`, `03-outline.md` を読み `slides.md` を執筆する。

## 対象ディレクトリの確認

執筆前に対象の発表ディレクトリを特定する。

- ユーザーが発表ディレクトリを指定している場合 → そのまま使う
- 指定がない場合 → **ユーザーに質問する**

  ```
  talks/ 配下のディレクトリが複数あります。どの発表のスライドを執筆しますか？
  （例: talks/2026-03-13-my-talk）
  ```

  `talks/` 直下のディレクトリ一覧を表示したうえで確認を取ること。自動選択しない。

## 事前確認

執筆前に以下を読む：

- `context/01-brief.md` — 発表前提・想定聴衆・一番伝えたいこと
- `context/02-raw-notes.md` — 素材・参考情報
- `context/03-outline.md` — スライド構成
- `docs/rule-slide.md` — スライドの書き方ルール（Frontmatter・クラス・順序など）

## 執筆後

`make build-image`, `make build-pdf`, `make dev`でレイアウト確認することをユーザーに案内する。
