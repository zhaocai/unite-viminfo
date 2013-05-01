" --------------- ------------------------------------------------------------
"           Name : scriptnames
"       Synopsis : unite source to grab vim scriptnames
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Mon 05 Nov 2012 08:19:11 AM EST
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


let s:unite_source = {
      \ 'name': 'vim/scriptnames',
      \ "description": 'candidates from vim scriptnames',
      \ }

function! s:unite_source.gather_candidates(args, context)
    redir => output
    silent execute 'scriptnames'
    redir END

    let scripts = split(output, "\n")
    let candidates = []
    for _ in scripts
        let [nr, fname ] = matchlist(_,'\v(\d+):\s*(.*)$')[1:2]
        call add(candidates, {
                \ "word": _,
                \ "source": "vim/scriptnames",
                \ "kind": "file",
                \ "action__path": unite#util#substitute_path_separator(
                \   fnamemodify(fname, ":p")),
                \ "action__directory": unite#util#substitute_path_separator(
                \   fnamemodify(fname, ":p:h")),
                \ } )
    endfor
    return candidates
endfunction

function! unite#sources#vim#scriptnames#define()
    return s:unite_source
endfunction


