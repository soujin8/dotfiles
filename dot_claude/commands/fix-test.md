# Fix test

指定したテストファイルを修正するためのコマンドです。
テストがパスするまで修正してください。

# Frontend

Reactコンポーネントの場合は以下のコマンドを実行して、実際のエラー内容を確認してから修正してください。

```bash
docker compose exec web yarn test <テストファイルパス>
```

# Backend

Ruby on Railsの場合は以下のコマンドを実行して、実際のエラー内容を確認してから修正してください。

```bash
docker compose exec web /home/apps/.rbenv/shims/rspec <テストファイルパス>
```
