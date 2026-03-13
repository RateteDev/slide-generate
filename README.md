# 📑 slide-generate

Marp を使った発表スライドの執筆・管理リポジトリ。
Claude Code のスキル・エージェントと連携し、ヒアリングから PDF 出力まで一貫して進められる。

## 🗂 ディレクトリ構成

```
talks/
  _template/          # 新規発表のテンプレート
  YYYY-MM-DD-{name}/  # 発表単位
    slides.md         # スライド本文（Marp）
    talk-theme.css    # テーマ CSS
    context/          # 01-brief / 02-raw-notes / 03-outline / 04-script
    assets/           # 画像・QR コードなど
    dist/             # ビルド成果物（HTML / PDF / PNG）
docs/
  rule-*.md           # スライド・各 context ファイルの記述ルール
scripts/              # ビルド補助スクリプト
```

## 🚀 クイックスタート

新規発表を始めるときは `_template/` をコピーして使う。

```bash
cp -r talks/_template talks/YYYY-MM-DD-{name}
```

## 🛠 主要コマンド

| コマンド | 内容 |
|----------|------|
| `make dev talks/{dir}` | ブラウザプレビューを起動 |
| `make build-image talks/{dir}` | PNG をスライドごとに生成 |
| `make build-pdf talks/{dir}` | PDF を生成 |
| `make build-all talks/{dir}` | HTML / PDF / PNG をまとめて生成 |
| `make gen-qr talks/{dir} URL=https://...` | QR コード画像を生成 |

## ✍️ スライド作成フロー

```
01-brief.md  →  02-raw-notes.md  →  03-outline.md  →  slides.md  →  ビルド  →  04-script.md
（前提を決める）  （素材を集める）    （構成を組む）    （執筆）      （確認）   （台本作成）
```

素材不足・構成の見直しが生じた場合は前のステップに戻る。

## 🤖 Claude Code スキル・エージェント

| 名前 | 種別 | 役割 |
|------|------|------|
| `slide-hearing` | スキル | tmux の hearing セッションで Claude をインタビュアーとして起動 |
| `slide-draft` | スキル | context/ をもとに slides.md を執筆 |
| `slide-ui-check` | エージェント | ビルド後の PNG のレイアウト問題を検出 |
| `slide-review` | エージェント | ルールに照らして slides.md の違反・改善点を指摘 |
| `slide-css-fix` | エージェント | slide-ui-check の報告をもとに CSS を修正 |
| `slide-research` | エージェント | イベント情報・技術的裏付けを調査 |

## 📐 ルールファイル

| ファイル | 内容 |
|----------|------|
| `docs/rule-slide.md` | slides.md の書き方（Frontmatter・クラス・構成順序） |
| `docs/rule-01-brief.md` | 発表ブリーフの書き方 |
| `docs/rule-02-raw-notes.md` | 調査・ヒアリングメモの書き方 |
| `docs/rule-03-outline.md` | アウトラインの書き方 |
| `docs/rule-04-script.md` | 台本の書き方 |
