" --------------- ------------------------------------------------------------
"           Name : vim/function
"       Synopsis : unite kind for vim function
"         Author : Zhao Cai <caizhaoff@gmail.com>
"       HomePage : https://github.com/zhaocai/unite-viminfo
"        Version : 0.1
"   Date Created : Sun 12 Aug 2012 10:06:14 PM EDT
"  Last Modified : Thu 13 Sep 2012 10:28:56 AM EDT
"            Tag : [ vim, unite, info ]
"      Copyright : © 2012 by Zhao Cai,
"                  Released under current GPL license.
" --------------- ------------------------------------------------------------



let s:kind = {
      \ 'name' : 'vimfunc',
      \ 'default_action' : 'narrow',
      \ 'action_table': {},
      \ 'alias_table' : {},
      \}



function! unite#kinds#vimfunc#define()
    " [ action ] breakadd
    let s:kind.action_table.breakadd = {
                \   'description': 'breakadd this function',
                \   'is_selectable': 1,
                \ }
    function! s:kind.action_table.breakadd.func(candidates)
        for candidate in a:candidates
            execute 'breakadd func ' candidate.funcname
        endfor
    endfunction


    " [ action ] breakpts
    " if globpath(&runtimepath, 'autoload/breakpts.vim') != ''
        let s:kind.action_table.breakpts = {
                    \   'description': 'open this function in BreakPts window',
                    \   'is_selectable': 1,
                    \ }
        function! s:kind.action_table.breakpts.func(candidates)
            if !exists(':BPListFunc')
                call unite#print_error("BreakPts is not available!")
                return 1
            endif
            for candidate in a:candidates
                silent! execute 'BPListFunc ' candidate.funcname
            endfor
        endfunction
    " endif

    return s:kind
endfunction




