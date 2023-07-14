# VimTootMastodon
Vimからマストドン鯖にTootを送信するプラグインです。
投稿の読み込み機能はありません


## Requirements
python3が実行可能である必要があります。
下記のライブラリが必要です。
```
pip install Mastodon.py
```


## 必要な設定
Mastodonの設定->開発からAPIKeyの発行が必要です。
必要なパーミッションは、write:statuses/投稿の送信のみです。
パーミッションを変更するたびにアクセストークンが変わることに注意してください。

下記の三つを設定してください。
```
let g:MastodonClientSecret = ""
let g:MastodonAccessToken  = ""
let g:MastodonBaseUrl      = ""
```


## Usage
下記のコマンドをサポートします。

- Mastodon
    投稿用のウィンドウを作成する。

- MastodonPost [ ReplyID / public / unlisted / private ]
    投稿用のウィンドウで実行した場合、そのバッファの内容を送信して閉じる。
    投稿後、vimのiレジスタに投降したIDが挿入されます。
    任意でオプションを一つ設定できます。

    - public/unlisted/private
        設定した場合、指定した公開設定が適用されます。
        指定しなかった場合、サーバー側でのデフォルトが使用される。

    - ReplyID
        指定した場合、指定した投稿へのリプライとして送信されます。


## License
MIT


## 注意事項
すべて自己責任でご使用ください。


## 他
このプラグインは送信専用ですが、デスクトップマスコットなどを使用することで、ブラウザ等へのウィンドウの切り替えをせずに閲覧、投稿IDの取得などをすることができます。
[GitHub - ambergon/chromeExtension_ukagakaClockWorkUkadonForSSP](https://github.com/ambergon/chromeExtension_ukagakaClockWorkUkadonForSSP)


## Author
ambergon



