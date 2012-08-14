" --------------- ------------------------------------------------------------
"           Name : vim/command
"       Synopsis : unite source to grab vim commands
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Tue 14 Aug 2012 02:20:19 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------



">=< Source [[[1 =============================================================
let s:source = {
      \ 'name': 'vim/command',
      \ 'is_volatile': 0,
      \ 'is_multiline' : 1,
      \ 'default_action' : 'open',
      \ "hooks": {},
      \ "syntax": "uniteSource__VimCommand",
      \ }

fun! unite#sources#commands#define()
    return s:source
endf


">=< Hooks [[[1 ==============================================================
fun! s:source.hooks.on_init(args, context) "                              [[[2

    exec 'highlight default link uniteSource__VimCommand_Name ' . 'Define'
endf

fun! s:source.hooks.on_syntax(args, context) "                            [[[2
    "Reference:
    "  unite#get_current_unite().abbr_head == ^

    let unite = unite#get_current_unite()


    " Command Name
    execute 'syntax region uniteSource__VimCommand_Name matchgroup=Delimiter start=/\%'
                \ . (unite.abbr_head + 2) . 'c\[\%(\s*\)/ end=/\%(\s*\)\]/'
                \ . ' oneline contained keepend containedin=uniteSource__VimCommand'
endf



">=< Gather Candidates [[[1 ==================================================
fun! s:source.gather_candidates(args, context)
    redir => output
    silent execute 'verbose command'
    redir END

    let lines = split(output, "\n")
    let candidates = []

    " remove header
    " -------------
    " let command_header_pattern='\s\+Name\s\+Args\s\+Range\s\+Complete\s\+Definition'
    " let i = 0
    " for _ in lines
    "     if _  !~# command_header_pattern
    "         let i += 1
    "     else
    "         break
    "     endif
    " endfor
    " let command_lines = remove(lines, 0, i)


    " parse each element?
    " ------------------
    "  not working because some of fields are empty.
    "  need to fix start column for each field
    " let command_line_pattern =
    "         \ '\(\%1c.\)\s' .
    "         \ '\(\%3c.\)\s' .
    "         \ '\%>4c\(\w\+\)\s\+' .
    "         \ '\(\S\{1,2}\)\s\+' .
    "         \ '\(\S\+\)\s\+' .
    "         \ '\(\S\+\)\s\+' .
    "         \ '\(.\+\)$'
    let command_line_pattern =
            \'\(\%1c.\)\s' .
            \'\(\%3c.\)\s' .
            \'\%>4c\(\w\+\)\s\+' .
            \'\(.\+\)$'

    let command_path_pattern =
                \'^\%(\s\+Last\sset\sfrom\s\)\(\f\+\)$'

    let i = 0
    for _ in lines[1:]
        if i%2 == 0
            let [_bang, _buf, _name, _other] = matchlist(_, command_line_pattern)[1:4]
        else
            let _path = matchlist(_, command_path_pattern)[1]

            call add(candidates, {
                \ "word"              : '[' . _name . '] ' . _path . "\n" . _bang . _buf . ' ' . _other,
                \ "kind"              : ['file', 'command', 'jump_list'],
                \ 'is_multiline'      : 1,
                \ "action__path": unite#util#substitute_path_separator(
                \   fnamemodify(_path, ":p")),
                \ "action__directory": unite#util#substitute_path_separator(
                \   fnamemodify(_path, ":p:h")),
                \ "action__command"  : _name . ' ',
                \ "action__pattern"  : '^\s*com.*\(\n\)\=.*' . _name,
                \ } )
        endif
        let i += 1
    endfor
    return candidates
endf



"▲ Modeline ◀ [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
