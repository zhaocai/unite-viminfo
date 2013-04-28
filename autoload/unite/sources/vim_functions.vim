" --------------- ------------------------------------------------------------
"           Name : vim/functions
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Wed 26 Sep 2012 08:06:05 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


" ============================================================================
" Settings:                                                               [[[1
" ============================================================================

call uinfo#zl#rc#set_default({
    \ 'g:unite_viminfo__function_delimiter'          : '⎜'      ,
    \ 'g:unite_viminfo__function_align_width'        : '39'     ,
    \ 'g:unite_viminfo__function_highligh_func_name' : 'Define' ,
    \ })









" ============================================================================
" Source:                                                                 [[[1
" ============================================================================
let s:source = {
      \ 'name'           : 'vim/functions'            ,
      \ 'is_volatile'    : 0                          ,
      \ 'default_action' : 'open'                     ,
      \ "hooks"          : {}                         ,
      \ "syntax"         : "uniteSource__VimFunction" ,
      \ }

function! unite#sources#vim_functions#define()
    return s:source
endfunction




" ============================================================================
" Hooks:                                                                  [[[1
" ============================================================================
function! s:source.hooks.on_init(args, context)

    let a:context.source__query = get(a:args, 0, '')

    let a:context.source__odd_line_pattern =
                \'^\%(\function\s*\)\(\S.\+\)$'

    let a:context.source__funcname_pattern =
                \'\(\%(<SNR>\d\+_\)\=\w.\+\)\%((.*)\)'

    let a:context.source__even_line_pattern = g:unite_viminfo_pathline_pattern

    exec 'highlight default link uniteSource__VimFunction_Name '
    \ . g:unite_viminfo__function_highligh_func_name
endfunction

function! s:source.hooks.on_syntax(args, context)
    execute 'syntax region uniteSource__VimFunction_Name matchgroup=Delimiter start=/'
                \ . '+\s/ end=/\%<100c'. g:unite_viminfo__function_delimiter . '/'
                \ . ' oneline contained keepend containedin=uniteSource__VimFunction'

endfunction



" ============================================================================
" Gather Candidates:                                                      [[[1
" ============================================================================
let s:cached_result = []
function! s:source.gather_candidates(args, context)
    if !a:context.is_redraw && !empty(s:cached_result)
        return s:cached_result
    endif
    let s:cached_result = []

    redir => output
    silent execute 'verbose function ' . a:context.source__query
    redir END

    let lines = split(output, "\n")


    let i = 0
    for _ in lines
        if i%2 == 0
            let _func = matchlist(_, a:context.source__odd_line_pattern)[1]
            let _name = matchlist(_func, a:context.source__funcname_pattern)[1]
        else
            let _path = matchlist(_, a:context.source__even_line_pattern)[1]

            call add(s:cached_result, {
                \ "word"              :  _name
                    \ . repeat(' ', g:unite_viminfo__function_align_width - strdisplaywidth(_name) - 1) . ' '
                    \ . g:unite_viminfo__function_delimiter . ' '
                    \ . _path . "\n"
                    \ . repeat(' ', g:unite_viminfo__function_align_width)
                    \ . _func,
                \ "kind"              : ['file', 'jump_list', 'vimfunc'],
                \ 'funcname'          : _name,
                \ 'is_multiline'      : 1,
                \ "action__path": unite#util#substitute_path_separator(
                \   fnamemodify(_path, ":p")),
                \ "action__directory": unite#util#substitute_path_separator(
                \   fnamemodify(_path, ":p:h")),
                \ "action__pattern"  : '^\s*fun.*' . _name,
                \ } )
        endif
        let i += 1
    endfor
    return s:cached_result
endfunction



" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :

