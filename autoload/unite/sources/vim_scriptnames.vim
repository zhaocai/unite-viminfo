" --------------- ------------------------------------------------------------
"           Name : scriptnames
"       Synopsis : unite source to grab vim scriptnames
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Wed 26 Sep 2012 08:04:41 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


let s:unite_source = {
      \ 'name': 'vim/scriptnames',
      \ "description": 'candidates from vim scriptnames',
      \ }

let s:cached_result = []
function! s:unite_source.gather_candidates(args, context)
    if !a:context.is_redraw && !empty(s:cached_result)
        return s:cached_result
    endif

    redir => output
    silent execute 'scriptnames'
    redir END

    let scripts = split(output, "\n")
    let s:cached_result = []
    for _ in scripts
        let [nr, fname ] = matchlist(_,'\v(\d+):\s*(.*)$')[1:2]
        call add(s:cached_result, {
                \ "word": _,
                \ "source": "vim/scriptnames",
                \ "kind": "file",
                \ "action__path": unite#util#substitute_path_separator(
                \   fnamemodify(fname, ":p")),
                \ "action__directory": unite#util#substitute_path_separator(
                \   fnamemodify(fname, ":p:h")),
                \ } )
    endfor
    return s:cached_result
endfunction

function! unite#sources#vim_scriptnames#define()
    return s:unite_source
endfunction


