# ルール: slides.md

## Frontmatter

```yaml
---
marp: true
theme: talk-theme
paginate: true
header: {発表タイトル短縮形}
footer: https://ratete.dev/works/{workSlug}
---
```

`workSlug` は英小文字 kebab-case でタイトルから生成（例: `ai-dev-setup`）。

## 全体構成

1. タイトル（`title`）
2. 自己紹介
3. 本編：章扉 + 説明 + 画像の繰り返し
4. まとめ
5. 参照ソース・フォローアップ・Q&A例（任意）
6. 最後のスライド（`closing-qr`）

## クラス一覧

| クラス | 用途 | 制約 |
|--------|------|------|
| `title` | 発表タイトル | 先頭1枚のみ |
| `chapter-title` | トピック導入 | 連続禁止・直後に通常スライドを挟む |
| `image-only` | 画像フルサイズ | テキスト・見出し不可 |
| `closing-qr` | 最後のスライド | Header/Footer/ページ番号は自動非表示 |

## トピックの順序ルール

各トピックは必ず **chapter-title → 説明 → image-only** の順で構成する。
いきなり画像を見せない。説明で文脈を作ってから画像で補強する。

```markdown
<!-- header: N. タイトル -->
<!-- _class: chapter-title -->

## N. タイトル

サブタイトル

---

説明スライド

---

<!-- _class: image-only -->

![bg](assets/xxx.png)
```

## chapter-title の命名ルール

- 番号を先頭に付ける（例: `1. 起動前ダッシュボードの設定`）
- タイトルは「何をしたか」を具体的に
- サブタイトルは「何が変わったか」

## Header のルール

- Frontmatter の `header` はデフォルト値
- 章ごとに `<!-- header: テキスト -->` で上書き
- **header のテキストは直後の `chapter-title` 見出しと完全一致させる**

## 特定スライドの注意

**参照ソース**: 一次情報・公式ドキュメントを3〜6件。多すぎると読まれない。
**closing-qr**: `h1: Thank you!` + 発表タイトル + QRコード + 公開URL（`footer` と同じ）。
