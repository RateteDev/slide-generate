---
name: slide-css-fix
description: slide-ui-check の報告をもとに talk-theme.css を修正するエージェント
tools: Read, Edit, Bash, Glob
model: sonnet
---

# slide-css-fix

`slide-ui-check` の問題レポートを受け取り、`talk-theme.css` を修正する。

## 手順

### 1. 現状把握

- `talk-theme.css` を読む
- 問題レポートの内容を確認する
- 対象スライドの `slides.md` のクラス・構造を確認する

### 2. 修正方針の決定

問題ごとに対応するCSSプロパティを判断する。

| 問題 | 主な対応箇所 |
|------|------------|
| テキストの切れ | `font-size`, `line-height`, `padding` |
| 余白の偏り | `padding`, `margin`, `align-content` |
| 画像表示のズレ | `background-size`, `object-fit` |
| header/footer の欠落 | クラスごとの `header`/`footer` 非表示設定 |

### 3. 修正

`talk-theme.css` を直接編集する。
変更箇所にはコメントで理由を記す（例: `/* テキスト切れ対応: font-size を縮小 */`）。
影響範囲が広い変更（グローバルな `font-size` など）は変更前に報告する。

### 4. 再確認

修正後に `slide-ui-check` を再実行するよう案内する。
