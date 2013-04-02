" --------------- ------------------------------------------------------------
"           Name : message
"       Synopsis : unite source to grab vim message
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Tue 02 Apr 2013 01:03:34 AM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------


let s:source = {
      \ 'name': 'vim/message',
      \ "description": 'candidates from vim message',
      \ 'default_action' : 'yank',
      \ 'default_kind' : 'word',
      \ 'syntax' : 'uniteSource__VimMessage',
      \ 'hooks' : {},
      \ }

function! s:source.gather_candidates(args, context)
    redir => output
    silent execute 'message'
    redir END

    let result = split(output, '\r\n\|\n')
    let candidates = []
    for _ in reverse(result)
        call add(candidates, {
                \ "word": _,
                \ "source": "vim/message",
                \ 'is_multiline' : 1,
                \ } )
    endfor
    return candidates
endfunction

function! s:source.hooks.on_syntax(args, context)
  let save_current_syntax = get(b:, 'current_syntax', '')
  unlet! b:current_syntax

  try
    syntax include @Vim syntax/vim.vim
    syntax region uniteSource__VimMessage_Vim
          \ start=' ' end='$' contains=@Vim containedin=uniteSource__VimMessage
  finally
    let b:current_syntax = save_current_syntax
  endtry
endfunction

function! unite#sources#vim_message#define()
    return s:source
endfunction


