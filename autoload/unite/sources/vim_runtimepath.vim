" --------------- ------------------------------------------------------------
"           Name : runtimepath
"       Synopsis : unite source to grab vim runtimepath
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Wed 26 Sep 2012 08:05:11 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


let s:unite_source = {
      \ 'name': 'vim/runtimepath',
      \ "description": 'candidates from vim runtimepath',
      \ }

let s:cached_result = []
function! s:unite_source.gather_candidates(args, context)
    if !a:context.is_redraw && !empty(s:cached_result)
        return s:cached_result
    endif

    let scripts = split(&runtimepath,",")
    let s:cached_result = []
    for _ in scripts
        call add(s:cached_result, {
                \ "word": _,
                \ "source": "vim/runtimepath",
                \ "kind": "directory",
                \ "action__directory": unite#util#substitute_path_separator(
                \   fnamemodify(_, ":p")),
                \ } )
    endfor
    return s:cached_result
endfunction

function! unite#sources#vim_runtimepath#define()
    return s:unite_source
endfunction


