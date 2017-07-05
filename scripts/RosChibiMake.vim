"
" @brief vim script to execute catkin_make
"
" @author Atsushi Sakai
"
" @copyright (c): 2014 Atsushi Sakai
"
" @license : GPL Software License Agreement

"
" @brief Execute Catkin Make
"
function! RosChibiMake()
  echo "chbi16_make"
  ! cd ~/AMSL_ros_pkg/roomba_robot_meiji/chibi16_control/;make
endfunction

" Command enable
command! RosChibiMake :call RosChibiMake()

