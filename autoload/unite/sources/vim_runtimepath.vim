" --------------- ------------------------------------------------------------
"           Name : runtimepath
"       Synopsis : unite source to grab vim runtimepath
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Mon 24 Sep 2012 02:57:18 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


let s:unite_source = {
      \ 'name': 'vim/runtimepath',
      \ "description": 'candidates from vim runtimepath',
      \ }

function! s:unite_source.gather_candidates(args, context)

    let scripts = split(&runtimepath,",")
    let candidates = []
    for _ in scripts
        call add(candidates, {
                \ "word": _,
                \ "source": "vim/runtimepath",
                \ "kind": "directory",
                \ "action__directory": unite#util#substitute_path_separator(
                \   fnamemodify(_, ":p")),
                \ } )
    endfor
    return candidates
endfunction

function! unite#sources#vim_runtimepath#define()
    return s:unite_source
endfunction


