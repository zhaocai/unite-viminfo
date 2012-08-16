" --------------- ------------------------------------------------------------
"           Name : vim/function
"       Synopsis : unite source to grab vim function
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Wed 15 Aug 2012 09:33:46 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------



">=< Source [[[1 =============================================================
let s:source = {
      \ 'name': 'vim/function',
      \ 'is_volatile': 0,
      \ 'default_action' : 'open',
      \ "hooks": {},
      \ "syntax": "uniteSource__VimFuntion",
      \ }

fun! unite#sources#function#define()
    return s:source
endf



">=< Hooks [[[1 ==============================================================
fun! s:source.hooks.on_init(args, context) "                              [[[2

    let a:context.source__query = get(a:args, 0, '')

    let a:context.source__odd_line_pattern =
                \'^\%(\function\s*\)\(\S.\+\)$'

    let a:context.source__funcname_pattern =
                \'\%(<SNR>\d\+_\)\=\(\w.\+\)\%((.*)\)'

    let a:context.source__even_line_pattern = g:unite_viminfo_pathline_pattern

    exec 'highlight default link uniteSource__VimFuntion_Name ' . 'Define'
endf

fun! s:source.hooks.on_syntax(args, context) "                            [[[2
    "Reference:
    "  unite#get_current_unite().abbr_head == ^

    let unite = unite#get_current_unite()


    " Command Name
    execute 'syntax region uniteSource__VimFuntion_Name matchgroup=Delimiter start=/\%'
                \ . (unite.abbr_head + 2) . 'c\[\%(\s*\)/ end=/\%(\s*\)\]/'
                \ . ' oneline contained keepend containedin=uniteSource__VimFuntion'
endf



">=< Gather Candidates [[[1 ==================================================
fun! s:source.gather_candidates(args, context)
    redir => output
    silent execute 'verbose function ' . a:context.source__query
    redir END

    let lines = split(output, "\n")
    let candidates = []


    let i = 0
    for _ in lines
        if i%2 == 0
            let _func = matchlist(_, a:context.source__odd_line_pattern)[1]
            let _name = matchlist(_func, a:context.source__funcname_pattern)[1]
        else
            let _path = matchlist(_, a:context.source__even_line_pattern)[1]

            call add(candidates, {
                \ "word"              : '[' . _name . '] ' . _path . "\n" . '  function ' . _func,
                \ "kind"              : ['file', 'jump_list'],
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
    return candidates
endf



"▲ Modeline ◀ [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :

