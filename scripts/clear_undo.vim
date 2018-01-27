"
" @brief vim script to clear undo history
"
" @author noriaki machinaka
"
" @copyright (c): 2017 noriaki machinaka
"
" @license : gpl software license agreement

"

command -nargs=0 ClearUndo call <sid>ClearUndo()
function! s:ClearUndo()
  let old_undolevels = &undolevels
  set undolevels=-1
  exe "normal a \<BS>\<Esc>"
  let &undolevels = old_undolevels
  unlet old_undolevels
endfunction


