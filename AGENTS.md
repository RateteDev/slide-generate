Marpスライドの執筆用レポジトリ。
スキルやサブエージェントを使用してユーザーの発表準備を支援を行う。

## 主要ファイル

| パス | 役割 |
|------|------|
| `talks/_template/` | 新規発表のテンプレート |
| `talks/<YYYY-MM-DD-{name}>/` | 発表単位。`slides.md`, `talk-theme.css`, `context/`, `assets/`, `dist/` を含む |
| `docs/rule-*.md` | コンテキストファイル・スライドの記述ルール |
| `Makefile` | 開発用のコマンド定義 |

## スライド作成フロー

各ステップは前後することがある。素材不足・構成の見直しが生じた場合は1つ前のステップに戻る。

```mermaid
flowchart LR
    A[context/01-brief.md<br>発表の前提を決める] --> B[context/02-raw-notes.md<br>素材を集める]
    B --> C[context/03-outline.md<br>構成を組む]
    C --> D[slides.md<br>スライド執筆]
    D --> E[make build-image<br>レイアウト確認]
    E -->|修正あり| D
    E -->|構成に問題| C
    E -->|素材不足| B
    E -->|OK| F[context/04-script.md<br>台本作成]
```

## 主要コマンド

| コマンド | 内容 |
|---------|------|
| `make build-image` | PNG を生成して `dist/images/` に出力 |
| `make build-pdf` | PDF を生成して `dist/` に出力 |
| `make dev` | ブラウザプレビューを起動 |
| `make watch` | ファイル変更を監視してリビルド |
