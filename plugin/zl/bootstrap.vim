if !exists('g:uinfo_zl_bundle_path') 
  let g:uinfo_zl_bundle_path = fnamemodify(expand("<sfile>"), ":p:h:h:h")
  let g:uinfo_zl_autoload_path = expand(g:uinfo_zl_bundle_path . '/autoload/uinfo/zl')
end

