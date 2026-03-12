# 開発ブログ記事候補一覧

`~/.claude`と`~/workspace/scripts`を調査し、設定の独自性、再現性、読者への実利、記事化しやすさで順位付けしました。

| 順位 | テーマ | 主な根拠ファイル | 何の設定・機能か | なぜ書くべきか | ブログ記事ドラフト |
|---|---|---|---|---|---|
| 1 | AI CLIの起動前ダッシュボード | `~/workspace/scripts/agents-startup/agents-startup.sh` | `claude`と`codex`の起動前に、設定ファイル、Skills、Prompts、MCP、モデル、利用枠を一覧表示するラッパーです。 | AIエージェントを「ただ起動する」から「状態を確認してから使う」へ変える発想が強く、見た目も実利も伝えやすいためです。 | AI CLIは起動コマンドそのものより、どの設定と利用枠で動くかを把握してから使うほうが実務では重要です。この仕組みでは、Skills、MCP、モデル、利用率を起動前にまとめて表示し、確認のために設定ファイルやWeb画面を往復する手間を消しています。CLIの手前に薄い観測レイヤーを置くと、運用の安心感が大きく変わることを紹介できます。 |
| 2 | Claude/CodexのHookをDiscordへ流す通知基盤 | `~/.claude/settings.json`、`~/.claude/commands/settings-hooks.md`、`~/workspace/scripts/agents-hooks-notify/agents-hooks-notify.sh`、`~/workspace/scripts/agents-hooks-notify/README.md` | Claudeの`Notification`と`Stop`、Codexの通知イベントを受けて、Discord Webhookへ整形済みメッセージを送る仕組みです。 | 承認待ちや完了を見逃さない運用改善として再現性が高く、個人開発でもチームでもそのまま応用しやすいためです。 | AIエージェントに張り付いて待つ運用は、集中を崩しやすく非効率です。この通知基盤ではClaudeとCodexのHookを受けてDiscordへ送信し、承認待ち、完了、最終メッセージを見逃さず扱えます。本文の正規化やDiscord Embed制限への対処まで実装されており、単なる通知ではなく「運用に耐えるAI監視」の話として展開できます。 |
| 3 | Claudeを正本にした設定同期と個人GitOps | `~/.claude/commands/settings-sync-agents.md`、`~/workspace/scripts/sync-claude-settings/sync-agents-settings.bash`、`~/workspace/scripts/sync-claude-settings/README.md` | `~/.claude`を正本として、Skills、Commands、`CLAUDE.md`を`~/.codex`へ同期し、変更があればcommit、push、通知まで行う運用です。 | 複数のAIツール設定を手で合わせる不毛さに対し、正本管理と自動同期で解決している点が本質的で、記事の骨格を作りやすいためです。 | ClaudeとCodexを併用し始めると、設定差分はすぐに破綻します。そこでClaude側を正本として同期し、ブランチ確認、二重起動防止、差分のGit記録、通知まで一本化した構成にしました。個人のdotfiles管理を、AI時代の構成管理へ拡張した事例として、DevOpsやGitOpsの文脈で読みやすい記事にできます。 |
| 4 | Claude Codeのステータスラインを使用率ダッシュボード化 | `~/.claude/settings.json`、`~/.claude/statusline-command.sh`、`~/.claude/commands/settings-claude-statusline.md` | `statusLine`で独自スクリプトを呼び、モデル名、コンテキスト使用率、進捗バー、利用状況ページへのリンクを表示する機能です。 | CLIを単なる入出力欄ではなく、作業状態が見えるUIへ変える事例として分かりやすく、スクリーンショット映えもするためです。 | Claude Codeは便利でも、いま何のモデルで、どれだけ文脈を使っているかが見えにくい場面があります。そこで`statusLine`を使い、モデル名と使用率を色付きバーで可視化し、必要なら利用状況ページへ飛べるようにしました。プロンプト設計だけでなく、CLIそのものを使いやすくする小さなUI改善として書ける題材です。 |
| 5 | AI利用ログを振り返りレポートに変える個人分析基盤 | `~/.claude/usage-data/report.html`、`~/.claude/usage-data/facets/00da162b-eeb8-4424-aaba-5f79aad466a7.json`、`~/.claude/usage-data/session-meta/00da162b-eeb8-4424-aaba-5f79aad466a7.json` | セッションごとの目的、摩擦、満足度、ツール利用数などを保持し、HTMLレポートとして振り返れる仕組みです。 | 「AIを使う」から「AI活用を計測して改善する」への一段深い話にでき、他の記事と差別化しやすいためです。 | AI支援開発は成果物だけでなく、どう使ったかを振り返ると改善速度が上がります。この仕組みでは、作業の目的、摩擦点、ツール利用数、満足度傾向までセッション単位で保存し、HTMLレポートとして見返せます。個人用のAI分析基盤として、感覚論に頼らず運用改善する視点を提示できるのが記事として強いポイントです。 |
| 6 | Bun移行を定着させるCLIガード | `~/workspace/scripts/prefer-bun/README.md`、`~/workspace/scripts/prefer-bun/bin/_prefer_bun_exec`、`~/workspace/scripts/prefer-bun/bin/npm`、`~/workspace/scripts/prefer-bun/bin/real-npm` | `npm`、`pnpm`、`npx`、`pnpx`の直接実行を止め、`bun`や`bunx`を促しつつ、`real-*`で例外的に本物を呼べる仕組みです。 | ルール周知ではなく、仕組みで行動を変える設計として実務感があり、読者が真似しやすいためです。 | ツール移行は「今後はBunを使う」と宣言するだけでは定着しません。この構成では`npm`や`pnpm`を叩くと警告を出して止め、標準経路を`bun`へ寄せています。一方で`real-npm`という退避路を残し、必要な例外だけ許可します。開発体験を壊さずに行動を変える運用設計として、実用的な記事にできます。 |
| 7 | 自作スキルをインデックス付きで育てる運用 | `~/.claude/commands/manage-skills.md`、`~/.claude/skills/skills-index.md` | 自作スキルに`my-`プレフィックスを付け、インデックス更新、発火確認、管理ルールまで含めて運用する仕組みです。 | 断片的なプロンプト集ではなく、再利用可能な個人拡張基盤として語れるため、知見の資産化という切り口が立つためです。 | AI活用がその場しのぎで終わらない人は、よく使う振る舞いをスキルとして管理しています。この環境では、自作スキルの命名規則、索引の更新、自然文での発火確認までルール化されていました。個人知識をチャットの履歴から引き剥がし、半構造化された運用資産に変える方法として紹介できます。 |

## 補足

1位から3位までは、独自性と再現性のバランスが特に良く、一本の記事としても連載テーマとしても展開しやすい候補です。

4位以降は単体記事にもできますが、上位記事の派生編や実装詳細編として出すとまとまりやすいです。
