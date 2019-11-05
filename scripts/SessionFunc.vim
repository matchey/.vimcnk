"
" @brief vim script to write, load, delete sessions
"
" @author matchey
"
" @copyright (c): 2019 matchey
"
" @license : GPL Software License Agreement

set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal

" session path
let s:session_path = expand('~/.vimcnk/.sessions')

if !isdirectory(s:session_path)
    call mkdir(s:session_path, "p")
endif

fun ListSessionFiles(A, L, P)
  let l:filelist = split(glob(s:session_path . '/*'), "\n")
  let l:matches = []
  for fname in l:filelist
    let l:basename = fnamemodify(fname, ':t')
    if l:basename =~ '^' . a:A
      call add(l:matches, l:basename)
    endif
  endfor
  return l:matches
endfun

" save session
command! -nargs=1 -complete=customlist,ListSessionFiles SaveSession call s:saveSession(<f-args>)
function! s:saveSession(file)
    execute 'silent mksession!' s:session_path . '/' . a:file
endfunction

" load session
command! -nargs=1 -complete=customlist,ListSessionFiles LoadSession call s:loadSession(<f-args>)
function! s:loadSession(file)
    execute 'silent source' s:session_path . '/' . a:file
endfunction

" delete session
command! -nargs=1 -complete=customlist,ListSessionFiles DeleteSession call s:deleteSession(<f-args>)
function! s:deleteSession(file)
    call delete(expand(s:session_path . '/' . a:file))
endfunction

