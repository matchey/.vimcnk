"
" @brief vim script
"
" @author Noriaki Machinaka
"
" @copyright (c): 2014 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"
" @brief catkin_make --pkg <editing_package_name>
"
function! RosMakePkg()
  let @p=expand("%:p")
  execute "normal o\<C-r>p\<ESC>6bDbdB\"pyiw3u"
  execute "normal :!cd\<Space>~/ros_catkin_ws/;catkin_make\<Space>--pkg\<Space>\<C-r>p\<CR>"
endfunction

" Command enable
command! RosMakePkg :call RosMakePkg()


