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
function! CppMake()
  let @r=@%
  if isdirectory('out')
	  " let s:outpath="\./out/"
	  execute "normal :!g++\<Space>-std=c++11\<Space>-o\<Space>\./out/\<C-r>r\<BS>\<BS>\<BS>\<BS>\<Space>\<C-r>r\<CR>"
  else
	  " let s:outpath="\./"
	  execute "normal :!g++\<Space>-std=c++11\<Space>-o\<Space>\./\<C-r>r\<BS>\<BS>\<BS>\<BS>\<Space>\<C-r>r\<CR>"
  endif
  " execute "normal :!g++\<Space>-std=c++11\<Space>-o\<Space>\./out/\<C-r>r\<BS>\<BS>\<BS>\<BS>\<Space>\<C-r>r\<CR>"
endfunction

" Command enable
command! CppMake :call CppMake()


