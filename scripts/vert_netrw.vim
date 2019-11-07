"
" @brief vim script to show RUN
"
" @author Noriaki Machinaka
"
" @copyright (c): 2016 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"
"
function! VertNetrw()
  set noea
  " let g:netrw_winsize=-120
  let g:netrw_preview=1
  let g:netrw_liststyle=3
  let l:winwidnet=30
  let l:winwidsrc=240
  if winnr("$") == 2
    let l:winwidsum = winwidth(1) + winwidth(2)
    if l:winwidsrc + l:winwidnet < l:winwidsum
      let l:winwidnet = l:winwidsum - l:winwidsrc
    endif
    execute "wincmd t"
    execute l:winwidnet . "vnew ."
    let l:winwidsrc = winwidth(2) + winwidth(3)
    execute "wincmd b"
    execute "vert res " . l:winwidsrc / 2
    execute "wincmd t"
  else
    execute l:winwidnet . "vnew ."
  endif
endfunction

" Command enable
command! VertNetrw :call VertNetrw()


