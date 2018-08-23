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

" noremap <silent> <Plug>SetRelativeNumber_j :<C-u>SetRelativeNumber j<CR>
" noremap <silent> <Plug>SetRelativeNumber_k :<C-u>SetRelativeNumber k<CR>
nnoremap <silent> <Plug>SetRelativeNumber_j :SetRelativeNumber j<CR>
nnoremap <silent> <Plug>SetRelativeNumber_k :SetRelativeNumber k<CR>
vnoremap <silent> <Plug>VSetRelativeNumber_j :VSetRelativeNumber j<CR>
vnoremap <silent> <Plug>VSetRelativeNumber_k :VSetRelativeNumber k<CR>

let g:srn_last_time = reltime()

" function SetRelativeNumber(...) " 既存の関数を再定義する場合は function!, 関数名は大文字で開始
function SetRelativeNumber(...) range " 既存の関数を再定義する場合は function!, 関数名は大文字で開始
	let elapsed = reltimestr(reltime(g:srn_last_time))

	let move_count = v:count ? v:count : 1

	if a:0 > 0
		if a:1 == 'j'
			call cursor(line(".") + move_count, col("."))
		elseif a:1 == 'k'
			call cursor(line(".") - move_count, col("."))
		endif
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

	let visu_count = a:lastline - a:firstline + 1
	let move_count = v:count ? v:count : 1
	let move_count = visu_count

	let vpos = getpos("v")
	let cpos = getpos(".")
	" let pos = getpos(".")

	call setpos('.', vpos)
	normal v
	call setpos('.', cpos)



	" echo getpos(".")
	" echo getpos("'<")
	" echo getpos("'>")
	" echo getpos("v")
	" echo visu_count
	" echo move_count
	" echo a:firstline
	" echo a:lastline

	" if visu_count != move_count
	" 	echo "VISUAL"
	" endif

	if a:0 > 0
		if a:1 == 'j'
			call cursor(line(".") + move_count, col("."))
		elseif a:1 == 'k'
			call cursor(line(".") - move_count, col("."))
		endif
	endif

	let elapsed_f = split(elapsed, '\.') " vim8.0以上からreltimefloat

	if str2nr(elapsed) == 0 && str2nr(elapsed_f[1][0]) < 2 && str2nr(elapsed_f[1][1]) < 9
		set relativenumber
	else
		set norelativenumber
	endif

	let g:srn_last_time = reltime()
endfunction

