"
" @brief vim script to clear undo history
"
" @author Noriaki Machinaka
"
" @copyright (c): 2017 Noriaki Machinaka
"
" @license : GPL Software License Agreement

"

command -nargs=0 ClearUndo call <sid>ClearUndo()
function! s:ClearUndo()
  let old_undolevels = &undolevels
  set undolevels=-1
  exe "normal a \<BS>\<Esc>"
  let &undolevels = old_undolevels
  unlet old_undolevels
endfunction


