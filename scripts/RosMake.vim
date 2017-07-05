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

if stridx(expand("%:p"), "ros_catkin_ws") != -1

		execute 'source' fnamemodify(expand('<sfile>'), ':h').'/CatkinMake_pkg.vim'
		execute 'source' fnamemodify(expand('<sfile>'), ':h').'/CatkinMakePkg_fromCMakeList.vim'

		let $V_ROS_ROOT='/opt/ros/kinetic/include'
		set path+=$V_ROS_ROOT
		"

		autocmd BufNewFile,BufRead *.launch set filetype=xml

		" let s:dein_dir = expand('~/.vimcnk/rc/plugins')
		" let s:dein_repo_dir = s:dein_dir . '/repos/github.com/taketwo/vim-ros'
		"
		" execute 'set runtimepath+=' . s:dein_repo_dir


		" NeoBundleSource vim-ros

		" let g:ros_build_system = 'catkin'
		" set &makeprg=catkin_make

		"nnoremap <Space>b gg
		"  nnoremap <Space>c :RosCatkinMake<Enter>
		"  nnoremap <Space>m :RosMakePkg<Enter>
		"  nnoremap <Space>m :RosMakePkgFromList<Enter>
		"  nnoremap <Space>r :RosRun<Enter>
		if stridx(expand("%:p"), ".cpp") != -1
				nnoremap <Space>m :RosMakePkg<Enter>
		elseif stridx(expand("%:p"), "CMakeList") != -1
				nnoremap <Space>m :RosMakePkgFromList<Enter>
		endif
endif


