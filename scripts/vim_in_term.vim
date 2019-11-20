" scriptencoding utf-8

" let g:synctermcwd_cd_command = 'tcd'

" function! Tapi_InTermEdit(_, cwd, fname) abort
function! Tapi_InTermEdit(bufnum,arglist) abort
  set noea
  execute 'cd ' . a:arglist[0]
  execute 'bel new ' . a:arglist[1]
  execute 'wincmd _'
endfunction

