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

if stridx(expand("%:p:r"), "cpp") != -1

		execute 'source' fnamemodify(expand('<sfile>'), ':h').'/CppMake.vim'
		execute 'source' fnamemodify(expand('<sfile>'), ':h').'/CppRun.vim'

		if stridx(expand("%:p"), ".cpp") != -1
				nnoremap <Space>m :CppMake<Enter>
				nnoremap <Space>r :CppRun<Enter>
		endif
endif


