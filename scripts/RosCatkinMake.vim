"
" @brief vim script to execute catkin_make
"
" @author Noriaki Machinaka
"
" @copyright (c): 2015 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"
" @brief Execute Catkin Make
"
function! RosCatkinMake()
  echo "RosCatkinMake"
  ! cd ~/ros_catkin_ws/;catkin_make
endfunction

" Command enable
command! RosCatkinMake :call RosCatkinMake()

