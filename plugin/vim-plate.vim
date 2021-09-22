" ------------------------------------------------------------------------------
" Globals
" ------------------------------------------------------------------------------

" Have we already loaded?
if exists('g:plate_loaded')
    finish
else
    let g:plate_loaded = v:true
endif

" From where should we read/write templates?
if !exists('g:plate_dir')
    let g:plate_dir = stdpath('config') . '/templates'
endif
call mkdir(g:plate_dir)

" Should we automatically insert a template when a new file is created?
if !exists('g:plate_auto')
    let g:plate_auto = 1
endif

" ------------------------------------------------------------------------------
" Functionality
" ------------------------------------------------------------------------------

" Replace the contents of the current buffer with the contents of `file`. Does
" not write to disk.
function! s:ReplaceBufferWith(file)
    %delete
    call append(0, readfile(a:file))
    $delete
    0
endfunction

" Replace the contents of the current buffer with the contents of the template
" `name`. Does not write to disk. Return TRUE if the template is found and FALSE
" otherwise.
function! s:ReplaceBufferWithTemplate(name)
    " Use 'template' as the default name if none is given.
    let name = a:name != '' ? a:name : 'template'
    let template = g:plate_dir . '/' . name . '.' . expand('%:e')

    if filereadable(template)
        call s:ReplaceBufferWith(template)
        return v:true
    else
        return v:false
    endif
endfunction
command! -nargs=? Template call <SID>ReplaceBufferWithTemplate(<q-args>)

if g:plate_auto == 1
    autocmd BufNewFile * Template
endif
