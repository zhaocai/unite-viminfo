function! unite#sources#vim#define()
    let unite_sources = []
    for s in ['functions', 'commands', 'mappings', 'message', 'scriptnames']
        call insert(unite_sources, unite#sources#vim#{s}#define())
    endfor
    return unite_sources
endfunction

