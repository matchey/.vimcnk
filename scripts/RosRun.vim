"
" @brief vim script to show ROSRUN
"
" @author Noriaki Machinaka
"
" @copyright (c): 2014 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"
" @brief Show ROSRUN
"
function! RosRun()
  let @r=@%
  10new
  execute "normal o\<C-r>r\<ESC>3b\"fyiw3bDbdB\"pyiw"
  execute "normal :r!rosrun\<Space>\<C-r>p\<Space>\<C-r>f\<CR>"
endfunction

" Command enable
command! RosRun :call RosRun()


