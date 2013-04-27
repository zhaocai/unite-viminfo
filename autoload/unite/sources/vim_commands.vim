" --------------- ------------------------------------------------------------
"           Name : vim/commands
"       Synopsis : unite source to grab vim commands
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Wed 26 Sep 2012 08:03:32 PM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------

" ============================================================================
" Settings:                                                               [[[1
" ============================================================================

call zl#rc#set_default({
    \ 'g:unite_viminfo__commands_delimiter'              : '⎜'      ,
    \ 'g:unite_viminfo__commands_align_width'            : '26'     ,
    \ 'g:unite_viminfo__commands_highlight_command_name' : 'Define' ,
    \ })


" ============================================================================
" Source:                                                                 [[[1
" ============================================================================
let s:source = {
    \ 'name'           : 'vim/commands'             ,
    \ 'is_volatile'    : 0                          ,
    \ 'is_multiline'   : 1                          ,
    \ 'default_action' : 'open'                     ,
    \ "hooks"          : {}                         ,
    \ "syntax"         : "uniteSource__VimCommands" ,
    \ }

function! unite#sources#vim_commands#define()
    return s:source
endfunction


" ============================================================================
" Hooks:                                                                  [[[1
" ============================================================================
function! s:source.hooks.on_init(args, context) 

    let a:context.source__query = get(a:args, 0, '')
    let a:context.source__odd_line_pattern =
    \'^'                 .
    \'\(\%1c.\)\s'       .
    \'\(\%3c.\)\s'       .
    \'\%>4c\(\w\+\)\s\+' .
    \'\(.\+\)'           .
    \'$'

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

    let a:context.source__even_line_pattern = g:unite_viminfo_pathline_pattern

    exec 'highlight default link uniteSource__VimCommands_Name '
    \ . g:unite_viminfo__commands_highlight_command_name
endfunction

function! s:source.hooks.on_syntax(args, context) 
    execute 'syntax region uniteSource__VimCommands_Name matchgroup=Delimiter start=/'
                \ . '+\s/ end=/\%<78c'. g:unite_viminfo__commands_delimiter . '/'
                \ . ' oneline contained keepend containedin=uniteSource__VimCommands'
endfunction



" ============================================================================
" Gather Candidates:                                                      [[[1
" ============================================================================
let s:cached_result = []
function! s:source.gather_candidates(args, context)
    if !a:context.is_redraw && !empty(s:cached_result)
        return s:cached_result
    endif

    redir => output
    silent execute 'verbose command ' . a:context.source__query
    redir END

    let lines = split(output, "\n")
    let s:cached_result = []

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

    let i = 0
    for _ in lines[1:]
        if i%2 == 0
            let [_bang, _buf, _name, _other] = matchlist(_, a:context.source__odd_line_pattern)[1:4]
        else
            let _path = matchlist(_, a:context.source__even_line_pattern)[1]

            call add(s:cached_result, {
                \ "word"              : _name
                    \ . repeat(' ', g:unite_viminfo__commands_align_width - strdisplaywidth(_name) - 1) . ' '
                    \ . g:unite_viminfo__commands_delimiter . ' '
                    \ . _path . "\n"
                    \ . repeat(' ', g:unite_viminfo__commands_align_width)
                    \ . _bang . ' ' . _buf . ' ' . _other,
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
    return s:cached_result
endfunction



" ============================================================================
" Modeline:                                                               [[[1
" ============================================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
