" VimTootMastodon
" Version: 0.0.1
" Author: ambergon
" License: MIT

if exists('g:loaded_VimTootMastodon')
  finish
endif
let g:loaded_VimTootMastodon = 1

if !has("python3")
    finish
endif

"if !exists('g:MastodonClientSecret')
"    finish
"endif
"if !exists('g:MastodonAccessToken')
"    finish
"endif
"if !exists('g:MastodonBaseUrl')
"    finish
"endif





function! VimTootMastodon#Comp(lead, line, pos )
    let l:matches = []
    for arg in [ "public" , "unlisted" , "private" ]
        if arg =~? '^' . strpart(a:lead,0)
            echo add(l:matches,arg)
        endif
    endfor
    return l:matches
endfunction

command! -nargs=0                                              Mastodon      call VimTootMastodon#NewMastodon(<f-args>)
command! -nargs=? -complete=customlist,VimTootMastodon#Comp    MastodonPost  call VimTootMastodon#PostMastodon(<f-args>)





















