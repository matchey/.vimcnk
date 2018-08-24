"
" @brief vim script to set relativenumber with jj or kk
"
" @author matchey
"
" @copyright (c): 2018 matchey
"
" @license : GPL Software License Agreement

"

" Command enable
command -range -nargs=1 SetRelativeNumber call SetRelativeNumber(<f-args>)
command -range -nargs=1 VSetRelativeNumber :<line1>,<line2>call VSetRelativeNumber(<f-args>)

let g:srn_last_time = reltime()

" function SetRelativeNumber(...) " 既存の関数を再定義する場合は function!, 関数名は大文字で開始
function SetRelativeNumber(...) range " 既存の関数を再定義する場合は function!, 関数名は大文字で開始
	let elapsed = reltimestr(reltime(g:srn_last_time))

	if a:0 > 0
		execute "normal! ".a:1
	endif

	let elapsed_f = split(elapsed, '\.') " vim8.0以上からreltimefloat

	if str2nr(elapsed) == 0 && str2nr(elapsed_f[1][0]) < 2 && str2nr(elapsed_f[1][1]) < 9
		set relativenumber
	else
		set norelativenumber
	endif

	let g:srn_last_time = reltime()
endfunction

function VSetRelativeNumber(...) range " 既存の関数を再定義する場合は function!, 関数名は大文字で開始
	let elapsed = reltimestr(reltime(g:srn_last_time))

	normal gv

	if a:0 > 0
		execute "normal! ".a:1
	endif

	let elapsed_f = split(elapsed, '\.') " vim8.0以上からreltimefloat

	if str2nr(elapsed) == 0 && str2nr(elapsed_f[1][0]) < 2 && str2nr(elapsed_f[1][1]) < 9
		set relativenumber
	else
		set norelativenumber
	endif

	let g:srn_last_time = reltime()
endfunction

