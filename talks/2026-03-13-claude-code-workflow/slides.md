---
marp: true
theme: talk-theme
paginate: true
header: Claude Code で個人開発が変わった話
footer: https://ratete.dev/works/claude-code-workflow
---

<!-- _class: title -->

# Claude Code で個人開発が変わった話

## コンテキストを渡す設計だけで爆速になる

2026-03-13 個人開発者LT会 vol.12

---

## 自己紹介

- 個人開発歴5年 / 週末エンジニア
- 個人ブログ・タスク管理ツールを細々と運用中
- 最近の口癖: **「CLAUDE.md に書いといて」**

---

<!-- header: 1. 毎週「どこまでやったっけ？」問題 -->
<!-- _class: chapter-title -->

## 1. 毎週「どこまでやったっけ？」問題

週末開発者の永遠の悩み

---

## 週末エンジニアあるある

- 土曜AM: コーヒーを淹れてやる気満々 ☕
- 土曜AM+10分: 「あれ、このファイル何のためにあるの？」
- 土曜PM: ようやく再開できた…… もう夕方 😩

> 実装時間より、コンテキスト回復時間が長い

---

<!-- _class: image-only -->

![bg](assets/context-cost.png)

---

<!-- header: 2. CLAUDE.md が全部解決する -->
<!-- _class: chapter-title -->

## 2. CLAUDE.md が全部解決する

コンテキスト回復コストがゼロになる

---

## CLAUDE.md = AIへの引き継ぎ書

- プロジェクトの目的・技術スタック
- 命名規則・ディレクトリ構成
- 「やってはいけないこと」

**Claude Code が起動するたびに自動で読み込まれる**

---

## CLAUDE.md がないと…

- AI: 「このファイルは何のためにありますか？」
- AI: 「どの技術スタックを使っていますか？」
- AI: 「テストは書きますか？」

毎回、同じ質問に答えている 😭

---

<!-- _class: image-only -->

![bg](assets/without-claude-md.png)

---

## CLAUDE.md があると…

- AIが最初からルールを知っている
- 「このプロジェクトは〇〇なので…」と提案してくれる
- コンテキスト回復コスト = **ほぼゼロ**

---

<!-- _class: image-only -->

![bg](assets/with-claude-md.png)

---

<!-- header: 3. context/ で状態を永続化 -->
<!-- _class: chapter-title -->

## 3. context/ で状態を永続化

状態をファイルに残してコンテキストロスをゼロにする

---

## 3ファイルで十分

| ファイル | 役割 |
|----------|------|
| `current-task.md` | 今やっていることと次のアクション |
| `decisions.md` | 設計の意思決定ログ |
| `gotchas.md` | ハマりポイントまとめ |

Claude Code に毎回読ませる → **AIが常に最新状態を把握**

---

<!-- _class: image-only -->

![bg](assets/context-dir.png)

---

## まとめ

- CLAUDE.md を書く → AIがプロジェクトを知る
- context/ を育てる → 状態がAIと共有される
- 週末30分の投資で作業時間が倍になった

**今夜、CLAUDE.md を作ってみてください 🚀**

---

## 参照ソース

- [Claude Code ドキュメント — CLAUDE.md](https://docs.anthropic.com/claude-code/claude-md)
- [Claude Code ドキュメント — メモリ管理](https://docs.anthropic.com/claude-code/memory)
- [Anthropic — Claude Code 公式サイト](https://claude.ai/claude-code)

---

<!-- _class: closing-qr -->

# Thank you!

Claude Code で個人開発が変わった話

![QR](assets/qr-code.png)

https://ratete.dev/works/claude-code-workflow
