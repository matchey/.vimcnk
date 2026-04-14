
let s:dir_path = expand('<sfile>:p:h')
let s:script_name = "jupy_run_all_cells.py"
let s:script_path = s:dir_path . '/' . s:script_name

function! WaitForExists(filename, timeout)
  let l:interval = 50
  let l:cnt = 0
  while !filereadable(a:filename)
    let l:cnt = l:cnt + l:interval
    if a:timeout < l:cnt
      return 1
    endif
    sleep 50ms
  endwhile
  return 0
endfunction

function! JupyRunAllCells(...)
  if exists('w:jupy_url')
    set autoread
    let l:filename = expand('%')
    if a:0 < 1
      let l:ofilename = l:filename
    else
      let l:ofilename = a:1
    endif
    echo 'run cells...'
    execute 'tab terminal ++hidden ++close python3 ' . s:script_path . " --url " . w:jupy_url . " "  . l:filename . " --output " . l:ofilename
    " call WaitForExists(l:ofilename,  5000)
    let l:res = call('WaitForExists', [l:ofilename,  5000])
    if l:res
      return 1
    endif
    checktime
    set noautoread
    redraw!
  else
    echo "url unset..."
    echo "call SetJupyUrl"
    return 1
  endif
  return 0
endfunction

function! SetJupyUrl(url)
  let w:jupy_url = a:url
endfunction

function! JupyRunAndConvertHtml()
  if exists('w:jupy_url')
    let l:filename = expand('%')
    let l:ofilename = l:filename . '.tmp.ipynb'
    let l:html_filename = l:filename . ".tmp.html"
    if filereadable(l:ofilename)
      echo 'remove file ' . l:ofilename
      return
    endif
    " call JupyRunAllCells(l:ofilename)
    let l:res = call('JupyRunAllCells', [l:ofilename])
    if l:res
      echo 'timout to create ' . l:ofilename
      return
    endif
    if filereadable(l:html_filename)
      echo 'remove file ' . l:html_filename
      return
    endif
    echo 'convert to html...'
    execute 'terminal ++hidden ++close jupyter nbconvert --to html ' . l:ofilename
    " call WaitForExists(l:html_filename,  5000)
    let l:res = call('WaitForExists', [l:html_filename,  5000])
    if l:res
      echo 'timout to create ' . l:html_filename
      return
    endif
    execute 'tabnew ' . l:html_filename
    execute 'HtmlPreview'
    execute 'tabprevious'
    execute 'bd ' . l:html_filename
    silent execute "!rm " . l:ofilename
    silent execute "!rm " . l:html_filename
    redraw!
  else
    echo "url unset..."
    echo "call SetJupyUrl"
  endif
endfunction

augroup JupyterRun
  au!
  command! -nargs=? JupyRunAllCells call JupyRunAllCells(<f-args>)
  command! -nargs=1 SetJupyUrl call SetJupyUrl(<f-args>)
  command! JupyRunAndConvertHtml call JupyRunAndConvertHtml()
  " au VimEnter,WinEnter *.ipynb nnoremap <Space>r :JupyRunAllCells<Space><Enter>
  au VimEnter,WinEnter *.ipynb nnoremap <Space>r :JupyRunAndConvertHtml<Space><Enter>
augroup END

