# CLAUDE.md

## Shell Guideline

- Zsh を使用する
- 文字列検索には`rg`を使用する

## Conversation Guidelines

- 常に日本語で会話する

## Development Philosophy

### Test-Driven Development (TDD)

- 原則としてテスト駆動開発（TDD）で進める
- 期待される入出力に基づき、まずテストを作成する
- 実装コードは書かず、テストのみを用意する
- テストを実行し、失敗を確認する
- テストが正しいことを確認できた段階でコミットする
- その後、テストをパスさせる実装を進める
- 実装中はテストを変更せず、コードを修正し続ける
- すべてのテストが通過するまで繰り返す

## Git Commit Guidelines

- コミットメッセージは日本語で書く
- git log で参照した過去のコミットメッセージを参考にする
- Conventional Commit を基本とする
- 1 行目のコミットの下には空白の行間を設ける
- 複数行の詳細なコミットメッセージを書く
