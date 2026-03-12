# 素材メモ

## 1. AI CLIの起動前ダッシュボード

`~/workspace/scripts/agents-startup/agents-startup.sh` をシェルに source すると、`claude` / `codex` / `gemini` コマンドがラッパー関数に置き換わる。起動のたびに設定情報と使用率を表示してから本体を呼び出す仕組みで、Claude には `--dangerously-skip-permissions`、Codex には `--dangerously-bypass-approvals-and-sandbox` が自動付与される。

表示項目は Claude が CLAUDE.md・Config・Skills・Commands・Agents・MCP・Limit（5h/7d使用率）、Codex が AGENTS.md・Config・Skills・Prompts・MCP・Model・Limit。使用率の取得方法はツールごとに異なり、Claude は `~/.claude/.credentials.json` の OAuth トークンで Anthropic API にダミーリクエストを送ってレスポンスヘッダー（`anthropic-ratelimit-unified-5h-utilization` / `7d`）を読み取り、Codex は `codex app-server --listen stdio://` をコプロセス起動して JSON-RPC の `account/rateLimits/read` で取得する。プログレスバーは20マス幅（█/░）で、使用率が50%を超えると黄、80%を超えると赤に変わり、リセット時刻と残り時間も JST で表示する。

### ヒアリング内容

**導入前の困っていたこと：**
- リミットがどの程度か知るためにWEBのダッシュボードを開く必要があり面倒だった

**なぜこの構成にしたのか：**
- 使用率の消費量から適切な単位での作業の切り分けが出来ているか、モデル選択が適切か、サブエージェントへの委譲・ツール設計が機能しているかを観測できるようにした

**何が楽になったのか：**
- 起動時に感覚で理解できるため作業の中断目安がつきやすくなった
- ClaudeCodeの方が使い勝手は良いがリミットが短いため、どの程度節約するかの判断材料になった

## 2. Claude/CodexのHookをDiscordへ流す通知

`~/workspace/scripts/agents-hooks-notify/agents-hooks-notify.sh` が通知の本体。`~/.claude/settings.json` の hooks に `Notification` と `Stop`（どちらも matcher 空 = 全イベント対象）を登録しており、スクリプトが受け取ったイベントに応じて Discord Webhook へ Embed 形式で送信する。

イベントの対応は、`claude:notification` の `permission_prompt` が「承認待ち」（オレンジ）、`claude:stop` が「応答完了 + 最終テキスト」（オレンジ）、`codex:notify` の `agent-turn-complete` が「応答完了 + 最終テキスト」（青）。Discord Embed の合計6000文字制限を超える場合は自動で切り詰めて省略注記を付ける。環境変数 `DISCORD_WEBHOOK_AGENTS_HOOKS_NOTIFY` が未設定なら何もせず終了する。

### ヒアリング内容

**導入前の困っていたこと：**
- スマホで通知を受け取ることができなかった

**なぜこの構成にしたのか：**
- スマホで通知を受け取るため

**何が楽になったのか：**
- メッセージ内のPRリンクから飛んでレビューがしやすくなった
- 複数セッションを同時操作している時に他のウィンドウで作業が終わったことが分かりやすくなった

## 3. Claudeを正本にした設定同期

`~/workspace/scripts/sync-claude-settings/sync-agents-settings.bash` が cron で30分ごとに実行される。`~/.claude` を正本として `~/.codex` へ同期し、`skills/` は rsync（`.system/` 除外）、`commands/` は `prompts/` へ rsync、`CLAUDE.md` は `AGENTS.md` として cp する。

実行前に `~/.claude` が git リポジトリかどうかと `~/.codex` の存在を確認し、`flock` でロックを取得して二重起動を防ぐ。ブランチが `main` でない場合は Discord に警告を送って中止する。変更があれば `chore(sync): snapshot YYYY-MM-DD HH:MM:SS` でコミットして `origin main` へ push し、変更サマリー・ファイル一覧・コミット URL を Discord に通知する。変更がなければ何もしない。

### ヒアリング内容

**導入前の困っていたこと：**
- 同期が面倒だった

**なぜこの構成にしたのか：**
- ClaudeCodeとCodexで同じ体験を持っていないと認知負荷が高まるため、常に揃えておきたかった

**何が楽になったのか：**
- 意識せずに同じ操作を行えるようになって快適
- GitHubへのPUSHも体験が良く、差分で変更を追えるし、別の環境でもcloneして配置するだけになった

## 4. Claude Codeのステータスライン

`~/.claude/statusline-command.sh` が `~/.claude/settings.json` の `statusLine` から呼び出される。表示内容は `[モデル名] ████████████░░░░░░░░ used:XX% | check limit` の形式で、モデル名は黄色、プログレスバーは使用率に応じて水色（30%未満）・緑（30%以上）・黄（50%以上）・赤（70%以上）と変わる。`check limit` は `https://claude.ai/settings/usage` へのハイパーリンク。

起動前ダッシュボード（agents-startup.sh）と責務を分けており、statusline-command.sh はセッション中の常時表示、agents-startup.sh は起動直後の一覧表示を担う。

### ヒアリング内容

**導入前の困っていたこと：**
- auto compactが発動すると文脈が失われて面倒なことになるから

**なぜこの構成にしたのか：**
- 残りコンテキストを視覚的に把握し残量に気を配るため

**何が楽になったのか：**
- 作業中のClaudeCodeが何の作業でトークンを使用しているかも確認できるようになった

## 5. PR formatスキル

`~/.claude/skills/my-pr-format/SKILL.md` に定義されたスキル。PR本文を「🎯 PRの概要・目的 / 📝 変更内容 / ✅ 検証 / 💬 補足・残課題」の4セクションで構成する。変更内容テーブルには `🟢 新規 / 🟡 変更 / 🔴 削除` の凡例を付け、概要セクションは「問題 → リスク → 対応」の流れで段落形式で書くルールになっている。UI変更を含む PR では `gh release create screenshots-pr-{N} --prerelease` で画像をアップロードし `<img>` タグで参照する。作成手順は `/tmp/pr-body.md` に書き出してから `gh pr create --body-file` で実行する形。

### ヒアリング内容

**導入前の困っていたこと：**
- Codexが書く文章はネストされた箇条書きや体言止めを多用した機械的・無機質な文章で読みづらく理解しづらい内容だった
- 圧縮した専門用語のようなものも使用してくる
- 毎回LLMのランダム性から別のフォーマットで送信してくるため、認知コストが高かった

**なぜこの構成にしたのか：**
- 同じフォーマットに統一させるため

**何が楽になったのか：**
- Codexはなるべくして読みやすい文章を出してくるようになった

## 6. playwright-cliによる見た目確認（余裕があれば）

`microsoft/playwright-cli` 製のスキルを `~/.claude/skills/playwright-cli/SKILL.md` として取り込んだもの（2026-02-23追加）。`allowed-tools: Bash(playwright-cli:*)` により、スキル実行中は playwright-cli コマンドのみに Bash 権限が絞られる。`playwright-cli screenshot --filename=xxx.png` でスクリーンショットを保存し、`open / goto / snapshot / close` が基本フロー。MCP版の設定はこの環境には存在しない。

### ヒアリング内容

**導入前の困っていたこと：**
- フロントエンド開発時に、PRでテキストのみで出されると判断に苦しむ
- AI自身もCSSには苦しむことがあり、意図しない折り返しなどでスタイルが崩れることがあった

**なぜこの構成にしたのか：**
- 自己改善ループをさせるため
- Cloudflare Workersのpreview URL発行が自動で行われるため、問題があった場合でもどこが変更されたかが分かりやすくするため

**何が楽になったのか：**
- 見た目確認によって不具合が視覚的に把握できるようになった
- 途中からplaywright-cliを使用したツールに切り替えることで、再現性・トークン節約になった

### 調査予定
- `/home/user/workspace/repos/web/docs/スクリーンショット撮影ツール.md` を確認し、使用しているツールについて詳しく調査する
