"
" @brief vim script to set relativenumber
"
" @author matchey
"
" @copyright (c): 2018 matchey
"
" @license : GPL Software License Agreement

"

" Command enable
command SetRelativeNumber :call SetRelativeNumber()
noremap <Plug>SetRelativeNumber_ :SetRelativeNumber<CR>

if !exists("g:setRelativeNumMap")
	let g:setRelativeNumMap = ''
endif

function UnsetAuto() " s:ローカル関数(privateメソッド) -> 未知の関数になっちゃう...
	set norelativenumber
	if g:setRelativeNumMap != ''
		exec 'nmap <silent> '. g:setRelativeNumMap .' <Plug>SetRelativeNumber_'
	endif
	autocmd! setRelativeNum
endfunction

function SetRelativeNumber() " 既存の関数を再定義する場合は function!, 関数名は大文字で開始
	set relativenumber
	" exec 'nunmap <silent> '. g:setRelativeNumMap
	augroup setRelativeNum
		autocmd!
		autocmd CursorMoved,InsertEnter * call UnsetAuto()
	augroup END
endfunction

if g:setRelativeNumMap != ''
	exec 'nmap <silent> '. g:setRelativeNumMap .' <Plug>SetRelativeNumber_'
endif


