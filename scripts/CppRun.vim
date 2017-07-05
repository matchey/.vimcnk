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
function! CppRun()
  let @r=@%
  10new
  execute "normal i=======実行結果=======\<ESC>"
  execute "normal :r!\./obj/\<C-r>r\<BS>\<BS>\<BS>\<BS>\<CR>"
  execute "normal gg\<C-w>w"
endfunction

" Command enable
command! CppRun :call CppRun()


