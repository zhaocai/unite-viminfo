" ------------- - ------------------------------------------------------------
" Bundle        : unite-viminfo
" Author        : Zhao Cai
" Email         : caizhaoff@gmail.com
" URL           :
" Version       : 0.1
" Date Created  : 07 Aug 2012 09:19:06 PM EDT
" Last Modified : Wed 15 Aug 2012 09:24:18 PM EDT
" Tag           : [ vim, info, unite  ]
" Flavor        : [ env:gui,  ]
" Dependence    : [ ]
" ------------- - ------------------------------------------------------------


"▶ Load Guard ▼ [[[1 =========================================================
if !zlib#rc#load_guard('unite_viminfo_' . expand('<sfile>:t:r'), 700, 100, ['has("python")','!&cp'])
    finish
endif

let s:cpo_save = &cpo
set cpo&vim


">=< Settings [[[1 ===========================================================

call zlib#rc#set_default({
            \ 'g:unite_viminfo_pathline_pattern' :
                \'^\%(\s\+Last\sset\sfrom\s\)\(\f\+\)$'
    \ })


">=< Public Interface [[[1 ===================================================



">=< Post Cleanup [[[1 =======================================================
let &cpo = s:cpo_save
unlet s:cpo_save

"▲ Modeline ◀  [[[1 ==========================================================
" vim: set ft=vim ts=4 sw=4 tw=78 fmr=[[[,]]] fdm=marker fdl=1 :

