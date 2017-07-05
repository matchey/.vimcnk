"
" @brief vim script to show RUN
"
" @author Noriaki Machinaka
"
" @copyright (c): 2014 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"
" @brief Show RUN
"
function! PyRun()
  let @r=@%
  10new
  execute "normal i=======実行結果=======\<ESC>"
  execute "normal :r!python\<Space>\<C-r>r\<CR>"
  execute "normal gg\<C-w>w"
endfunction

" Command enable
command! PyRun :call PyRun()


