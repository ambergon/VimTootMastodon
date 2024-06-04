
python3 << EOF
# -*- coding: utf-8 -*-
import vim
import re
from mastodon import Mastodon
class VimTootMastodon:
    mastodon     = ""
    clientSecret = ""
    accessToken  = ""
    baseUrl      = ""

    def __init__( self ):
        print( "VimTootMastodon init" )
        self.clientSecret = vim.vars["MastodonClientSecret"].decode( encoding='utf-8') 
        self.accessToken  = vim.vars["MastodonAccessToken"].decode( encoding='utf-8') 
        self.baseUrl      = vim.vars["MastodonBaseUrl"].decode( encoding='utf-8') 

        self.mastodon = Mastodon(
        client_secret   = self.clientSecret,
        access_token    = self.accessToken ,
        api_base_url    = self.baseUrl )


    #引数はどちらのみ
    #投稿先IDを特定のレジスタに入れとくか。
    def PostMastodon( self , arg = "" ):

        text = ""
        for line in vim.current.buffer[:]:
            text = text + line + "\n"

        if( arg == "" ):
            x = self.mastodon.toot( text )
            vim.command( 'let @i = "' + str( x.id ) + '"' )
            vim.command( "bw" )

        elif( arg == "public" or arg == "unlisted" or arg == "private" ):
            x = self.mastodon.status_post( status=text , in_reply_to_id=None , media_ids=None, sensitive=False, visibility=arg , spoiler_text=None, language=None, idempotency_key=None, content_type=None, scheduled_at=None, poll=None, quote_id=None)
            vim.command( 'let @i = "' + str( x.id ) + '"' )
            vim.command( "bw" )

        elif re.fullmatch( r'^[0-9]+$' , arg ):
            #投稿先の公開状態を取得する。
            reply = self.mastodon.status( arg )

            x = self.mastodon.status_post( status=text , in_reply_to_id=arg , media_ids=None, sensitive=False, visibility=reply.visibility , spoiler_text=None, language=None, idempotency_key=None, content_type=None, scheduled_at=None, poll=None, quote_id=None)
            vim.command( 'let @i = "' + str( x.id ) + '"' )
            vim.command( "bw" )

        else:
            print( "no match" )


    #mastodon.pyの公式説明によると、offset/min_id/max_idでページネーションせよとのことだが、
    #min_id/max_idはaccount_idの帯域指定であって一度に検索する量ではないように見える・・・
    #offsetは望みの通り動作する。
    def SearchMastodon( self , SearchWord , Flag = 0 , User_id = "" ):
        del vim.current.buffer[:]
        # サーバ全体検索
        if Flag == 0 :
            a = self.mastodon.search( SearchWord , result_type="statuses" )

        # 自分の投稿を検索
        elif Flag == 1 :
            SearchID = self.mastodon.me()
            a = self.mastodon.search( SearchWord , account_id = SearchID.id ,result_type="statuses")

        # 指定ユーザの検索
        elif Flag == 2 and User_id != "" :
            search_account_id = ""
            search_accounts = self.mastodon.account_search( User_id , limit=None )
            for search_account in search_accounts :
                # 完全一致するIDを検索する。
                # @ユーザー名@fedibird.comなど。
                # print( search_account[ 'username' ] )
                if search_account[ 'acct' ] == User_id :
                    search_account_id = search_account[ 'id' ]
                    break

            # ヒットしなければ終了
            if search_account_id == "" :
                #vim.command( 'close' )
                # 削除したいバッファ名
                buffer_name = 'VimMastodon:search'
                # バッファを検索して削除
                for buffer in vim.buffers:
                    if buffer.name and buffer_name in buffer.name:
                        vim.command(f'bdelete {buffer.number}')
                        break
                print( "完全一致するユーザ名がありませんでした。" )
                return ""

            a = self.mastodon.search( SearchWord , account_id = search_account_id ,result_type="statuses")

        else :
            print( "引数が正しくない。" )
            return ""

        num = 0
        text = ""
        vim.current.buffer.append( "ヒット件数 : " + str( len( a["statuses"] ) ) )
        for statuse in a["statuses"] :
            num = num + 1

            vim.current.buffer.append( str( num ) + " . " + str( statuse.created_at ) + " / TootID  : " + str( statuse.id ) )
            vim.current.buffer.append( str( statuse.uri ) )
            #改行処理は向いていない。
            text = re.sub( "<br />" , "\n" , statuse.content )
            text = re.sub( "<.*?>" , "" , text )
            texts = text.split( "\n" )
            for line in texts :
                vim.current.buffer.append( line )

            vim.current.buffer.append( "" )

        del vim.current.buffer[0]
        return ""




VimTootMastodonInst   = VimTootMastodon()
EOF

"指定のサイズでバッファを開く。
"保存をしないように。
"消去しても止められないように。
function! VimTootMastodon#NewMastodon()
    "既に開いている場合処理しないように。
    if expand('%:t') != "VimMastodon:post"
        "newMastodon
        10sp VimMastodon:post

        setl buftype=nowrite
        setl encoding=utf-8
        setl bufhidden=delete
    endif
endfunction






"function! VimMarkdownWordpress#pycmd(pyfunc)
"現在のバッファ名を比較したい。
function! VimTootMastodon#PostMastodon( ... )
    "仕様バッファーが特定のモノの時だけ動作
    if expand('%:t') == "VimMastodon:post"
        "let l:open  = ""
        "let l:reply = ""
        "if len( a:000 ) > 0 
        "    if a:1 == "unlisted" 
        "        let l:open = "unlisted"
        "    elseif a:1 == "private"
        "        let l:open = "private"
        "    elseif a:1 =~ "[0-9]\*"
        "        let l:reply = a:1
        "    endif
        "endif

        if len( a:000 ) > 0 
            let s:x = py3eval( 'VimTootMastodonInst.PostMastodon("' . a:1 . '")' )
        else
            let s:x = py3eval( 'VimTootMastodonInst.PostMastodon()' )
        endif
    endif
endfunction


" if len( a:000 ) == 1
" else
" endif





"検索ワード...
function! VimTootMastodon#SearchMastodon( ... )
    call VimTootMastodon#MakeSearchWindow()
    let l:x = py3eval( 'VimTootMastodonInst.SearchMastodon("' . a:1 . '")' )
endfunction
"検索ワード...
function! VimTootMastodon#SearchMastodonMe( ... )
    call VimTootMastodon#MakeSearchWindow()
    let l:x = py3eval( 'VimTootMastodonInst.SearchMastodon("' . a:1 . '" , 1 )' )
endfunction
" 検索対象 検索ワード...
function! VimTootMastodon#SearchMastodonOther( ... )
    " 分割して、先頭の文字を引っ張りだす。
    " それ以外を結合してAnd検索文字として使う。
    let l:args  =   split( a:1 , " " )
    if len( l:args ) < 2 
        echo "plz args >= 2"
        return
    endif
    let l:user_name     = l:args[0]

    let l:i             = 0
    let l:search_word   = ""
    for l:arg in l:args
        let l:i = l:i + 1
        " 最初の引数をuser名としてカット。
        if l:i == 1 
            continue
        endif
        if l:search_word == "" 
            let l:search_word = l:arg
        else
            let l:search_word = l:search_word . " " .  l:arg
        endif
    endfor
    " echo l:user_name
    " echo l:search_word
    call VimTootMastodon#MakeSearchWindow()
    let l:x = py3eval( 'VimTootMastodonInst.SearchMastodon("' . l:search_word . '" , 2 , "' . l:user_name . '"  )' )

    " 配列から先頭のものを引っ張り出す。
    " echo  a:1
    " call s:A( "cc" , "dd")
endfunction
function! s:A( ... )
    echo  a:1
endfunction


" 検索窓を作成する。
"{{{
function! VimTootMastodon#MakeSearchWindow()
    let num = bufnr( "VimMastodon:search" )
    "指定した名前のバッファが存在しない。
    if num == -1 
        vs VimMastodon:search
        setl buftype=nowrite
        setl encoding=utf-8
        setl bufhidden=delete
    else
        let window = win_findbuf( num )
        "ウィンドウが開いていない
        if empty( window )
            vs VimMastodon:search
            setl buftype=nowrite
            setl encoding=utf-8
            setl bufhidden=delete
        else
            "開いているならウィンドウへ移動
            call win_gotoid( window[0] )
        endif
    endif
endfunction


"}}}



