" --------------- ------------------------------------------------------------
"           Name : message
"       Synopsis : unite source to grab vim message
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Tue 02 Apr 2013 12:51:02 AM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


let s:unite_source = {
      \ 'name': 'vim/message',
      \ "description": 'candidates from vim message',
      \ }

function! s:unite_source.gather_candidates(args, context)
    redir => output
    silent execute 'message'
    redir END

    let scripts = split(output, "\n")
    let candidates = []
    for _ in reverse(scripts)
        call add(candidates, {
                \ "word": _,
                \ "source": "vim/message",
                \ "kind": "word",
                \ } )
    endfor
    return candidates
endfunction

function! unite#sources#vim_message#define()
    return s:unite_source
endfunction


