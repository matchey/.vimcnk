
augroup save_last_sesstion
	autocmd!
	" autocmd VimLeave * call SaveSession(_previous)
	autocmd QuitPre * SaveSession _previous
augroup END

" QuitPre               :quit を使ったとき、本当に終了するか決定する前
" ExitPre               Vimを終了するコマンドを使ったとき
" VimLeavePre           Vimを終了する前、viminfoファイルを書き出す前
" VimLeave              Vimを終了する前、viminfoファイルを書き出した後

