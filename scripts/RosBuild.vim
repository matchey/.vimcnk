"
" @brief vim script to execute ros_build_make
"
" @author Noriaki Machinaka
"
" @copyright (c): 2014 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"
" @brief Execute ros_build_make
"
function! RosBuild()
  echo "RosBuild"
  ! cd %:p:h:h;make
endfunction

" Command enable
command! RosBuild :call RosBuild()

