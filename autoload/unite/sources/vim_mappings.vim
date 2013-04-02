" --------------- ------------------------------------------------------------
"           Name : vim/mappings
"       Synopsis : unite source to grab vim mappings
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Wed 10 Oct 2012 12:42:16 AM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------

">=< Settings [[[1 ===========================================================

call zl#rc#set_default({
    \ 'g:unite_viminfo__mappings_delimiter'              : '⎜'      ,
    \ 'g:unite_viminfo__mappings_align_width'            : 14       ,
    \ 'g:unite_viminfo__mappings_highlight_mapping_name' : 'Define' ,
    \ })


">=< Source [[[1 =============================================================
let s:source = {
      \ 'name': 'vim/mappings',
      \ 'is_volatile': 0,
      \ 'is_multiline' : 1,
      \ 'default_action' : 'open',
      \ "filters": ['converter_relative_word', 'matcher_regexp', 'sorter_default' ],
      \ "hooks": {},
      \ "syntax": "uniteSource__VimMappings",
      \ }

function! unite#sources#vim_mappings#define()
    return s:source
endfunction


">=< Hooks [[[1 ==============================================================
function! s:source.hooks.on_init(args, context) "                         [[[2

    let a:context.source__query = get(a:args, 0, '')
    let a:context.source__buffer = get(a:args, 1, bufnr('%'))
    let a:context.source__old_buffer = bufnr('%')

    let a:context.source__odd_line_pattern = '^'
                        \ . '\(.\{3}\)'
                        \ . '\(\S\+\)\s\+'
                        \ . '\(\S.\+\)$'

    let a:context.source__even_line_pattern = g:unite_viminfo_pathline_pattern

    exec 'highlight default link uniteSource__VimMappings_Map '
    \ . g:unite_viminfo__mappings_highlight_mapping_name
endfunction

function! s:source.hooks.on_syntax(args, context) "                       [[[2

    execute 'syntax region uniteSource__VimMappings_Map matchgroup=Delimiter start=/+\s/'
                \ . ' end=/\%<78c'. g:unite_viminfo__mappings_delimiter . '/'
                \ . ' oneline contained keepend containedin=uniteSource__VimMappings'
endfunction



">=< Gather Candidates [[[1 ==================================================
function! s:source.gather_candidates(args, context)

    if a:context.source__buffer != a:context.source__old_buffer
        execute 'buffer' a:context.source__buffer
    endif


    redir => map_output
    silent execute 'verbose map ' . a:context.source__query
    redir END

    redir => imap_output
    silent execute 'verbose imap ' . a:context.source__query
    redir END

    if a:context.source__buffer != a:context.source__old_buffer
        execute 'buffer' a:context.source__old_buffer
    endif

    let lines = split(map_output, "\n") + split(imap_output, "\n")

    let results = []


    let i = 0
    for _ in lines
        if _ =~ "No mapping found" || _ =~ '^\s*$'
            continue
        endif
        if i%2 == 0

            let [_mode, _map, _word] = matchlist(_, a:context.source__odd_line_pattern)[1:3]

            let _mode = substitute(_mode,'\s','','ge')

            if match(_mode, 'n') != -1 || _map =~ '^<SNR>' || _map =~ '^<Plug>'
                let _nmap = ''
            else
                let _nmap = substitute(_map, '<NL>', '<C-j>', 'g')
                let _nmap = substitute(_nmap, '\(<.*>\)', '\\\1', 'g')
            endif
        else
            try
                let _path = matchlist(_, a:context.source__even_line_pattern)[1]
            catch /^Vim\%((\a\+)\)\=:E/
                let _path = ''
                let i += 1
            endtry

            let candidate = {
                    \ "word"              : _map
                        \ . repeat(' ', g:unite_viminfo__mappings_align_width - strdisplaywidth(_map._mode) - 1) . ' '
                        \ . _mode . g:unite_viminfo__mappings_delimiter . ' '
                        \ . _path . "\n"
                        \ . repeat(' ', g:unite_viminfo__mappings_align_width)
                        \ . _word ,
                    \ "kind"              : ['word'],
                    \ 'is_multiline'      : 1,
                    \ }

            if _nmap != ''
                let candidate.action__command = 'execute "normal ' . _nmap . '"' . ' '
                call extend(candidate.kind, ['command'])
            endif

            if _path != ''
                let candidate.action__path      = unite#util#substitute_path_separator(
                            \   fnamemodify(_path, ":p"))
                let candidate.action__directory = unite#util#substitute_path_separator(
                            \   fnamemodify(_path, ":p:h"))
                let candidate.action__pattern   = '^\s*\a\{0,5}map.*\V' . _map

                call extend(candidate.kind, ['file', 'jump_list'] )
            endif

            call add(results, candidate)
        endif
        let i += 1
    endfor
    return results
endfunction



"▲ Modeline ◀ [[[1 ===========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fdm=marker fmr=[[[,]]] fdl=1 :
