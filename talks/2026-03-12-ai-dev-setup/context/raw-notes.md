# 素材メモ

## 実行環境の分離

- 普段使いはWindows、開発作業はLinux側に寄せる構成
- 当初はHetznerを使っていたが、入力遅延やビルド速度の遅さが気になった
- 現在は自宅のLaptopを常時稼働させる形へ移行
- 発表資料や展示用リポジトリが入った実機へそのまま接続できるため、作業と発表の切り替えがしやすい
- Windows側はGPUが必要なモデルのダウンロードや、気になったツールを試す場所として残している

## Claude Codeのステータスライン

- 使用中モデルとトークン使用率がすぐ見えるようにカスタマイズ
- セッションを続けるか、区切るか、別の進め方へ切り替えるかを早めに判断しやすくなった
- 見た目の変更というより、判断コストの削減として効いている

## playwright-cliによる見た目確認

- MCP版ではなくplaywright-cliを使用。手元のフローに自然に乗ることを優先
- 指定パスのスクリーンショットを保存し、変更前後を比較できるようにした
- AIにも確認を手伝わせているが、小さな崩れは見逃すことがある
- 最終確認は自分でブラウザを見る運用を維持

## Xの1tweet fetch用MCP

- 自作の1tweet fetch用MCPを利用
- 長い投稿でもスクリーンショットやコピペを挟まずに扱える
- 新しい機能や知らない話題を調べるときの入口が短くなった

## Claude CodeとCodexの使い分け

- どちらかに統一せず、得意分野で使い分け
- Claude Codeは日本語表現や人向けの整理に強い
- Codexは実装面の改善や原因分析に向いている
- 設定やコマンド群は同期しつつ、会話の文脈は必要に応じて手動で受け渡す運用

## 参考リンク

- [Anthropic Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Playwright Screenshots](https://playwright.dev/docs/screenshots)
- [OpenAI Codex README](https://github.com/openai/codex)
- [Model Context Protocol Introduction](https://modelcontextprotocol.io/introduction)
