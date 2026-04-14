"
" Automatically saves GitHub Copilot logs to a specified directory
" every time a file is saved in Vim/Neovim.
"
" @author Noriaki Machinaka
"
" @copyright (c): 2025 Noriaki Machinaka
"

if !exists('g:copilot_auto_log_dir')
  let g:copilot_auto_log_dir = expand('~/.vimcnk/.copilot_logs')
endif


function! s:save_copilot_log_to_file()
  if !exists('*copilot#logger#GetLogs') || !exists('*copilot#logger#Clear')
    return
  endif

  let l:current_file_path = expand('%:p')
  if empty(l:current_file_path)
    return
  endif

  let l:logs = copilot#logger#GetLogs()

  if empty(l:logs)
    return
  endif

  if !isdirectory(g:copilot_auto_log_dir)
    call mkdir(g:copilot_auto_log_dir, 'p')
  endif

  let l:log_filename = l:current_file_path
  let l:log_filename = substitute(l:log_filename, ':', '', 'g')
  let l:log_filename = substitute(l:log_filename, '[/\\]', '%', 'g')
  let l:log_filename .= '.log'
  let l:log_filepath = g:copilot_auto_log_dir . '/' . l:log_filename

  call writefile(l:logs, l:log_filepath, 'a')

  call copilot#logger#Clear()
endfunction

augroup CopilotAutoLogger
  autocmd!
  autocmd BufWritePost * call s:save_copilot_log_to_file()
augroup END
