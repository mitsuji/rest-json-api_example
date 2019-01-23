# REST JSON API by Classic ASP



## 開発に使うツール

curl https://curl.haxx.se/download.html

jq   https://stedolan.github.io/jq/download/



## DBの設定

テスト用のテーブルを作成する


## IIS の設定

サイトの管理のハンドラマッピングのASPでPUT,DELETEを許可

Guideman を設定する



## コマンド


curl -X GET http://127.0.100.7/abcd1234 | jq .


curl -X GET http://127.0.100.7/v1/todolist/todo | jq .

curl -X POST http://127.0.100.7/v1/todolist/todo -d "content=todo1" | jq .


curl -X GET http://127.0.100.7/v1/todolist/2 | jq .

curl -X PUT http://127.0.100.7/v1/todolist/todo/2 -d "content=todotodo2" | jq .

curl -X DELETE http://127.0.100.7/v1/todolist/todo/2 | jq .





