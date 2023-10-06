# VimTootMastodon
Vimからマストドンサーバーに投稿を送信するプラグインです。<br>
投稿の読み込み機能はありません。<br>


## Requirements
python3が実行可能である必要があります。<br>
下記のライブラリが必要です。<br>
```
pip install Mastodon.py
```


## 必要な設定
Mastodonの設定->開発からAPIKeyの発行が必要です。<br>
必要なパーミッションは、write:statuses/投稿の送信とread:statuses/すべての投稿の読み取りです。<br>
読み取りはリプライ先の公開状態を取得し、同じ公開状態で送信するのに使用します。<br>

パーミッションを変更するたびにアクセストークンが変わることに注意してください。<br>
下記の三つを設定してください。<br>
```
let g:MastodonClientSecret = ""
let g:MastodonAccessToken  = ""
let g:MastodonBaseUrl      = ""
```


## Usage
下記のコマンドをサポートします。<br>

- Mastodon<br>
    投稿用のウィンドウを作成する。<br>

- MastodonPost [ ReplyID / public / unlisted / private ]<br>
    投稿用のウィンドウで実行した場合、そのバッファの内容を送信して閉じる。<br>
    投稿後、vimのiレジスタに投降したIDが挿入されます。<br>
    任意でオプションを一つ設定できます。<br>

    - public/unlisted/private<br>
        設定した場合、指定した公開設定が適用されます。<br>
        指定しなかった場合、サーバー側でのデフォルトが使用される。<br>

    - ReplyID<br>
        指定した場合、指定した投稿へのリプライとして送信されます。<br>
        公開設定はリプライ先と同じもとになる。

- MastodonSearch <word word...><br>
    マストドンを検索します。<br>
    半角スペースを使用することでAND検索になります。

- MastodonSearchMe <word word...><br>
    自分の投稿のみを検索します。



## License
MIT


## 注意事項
すべて自己責任でご使用ください。


## Author
ambergon



