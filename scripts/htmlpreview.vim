let s:pyscript = expand('<sfile>:p:h') . '/htmlpreview.py'

function! SetViewerIp(ip)
  let s:viewer_ip = a:ip
endfunction

function! s:update_preview()
  if exists('s:viewer_ip')
    let l:ip = s:viewer_ip
  else
    let l:ip = 'localhost'
  endif
  let l:url = 'http://' . l:ip . ':8087/'
  let ret = webapi#http#post(l:url, {
  \ "data" : join(getline(1, line('$')), "\n"),
  \ "type" : &filetype
  \})
  echo ret.content
endfunction

function! s:htmlpreview(bang)
  if a:bang == '!'
    if has('win32') || has('win64')
      if exists('g:htmlpreview_python_path')
        silent exe printf("!start %s %s",
        \ shellescape(g:htmlpreview_python_path),
        \ shellescape(s:pyscript))
      else
        silent exe "!start pythonw ".shellescape(s:pyscript)
      endif
    else
      if exists('g:htmlpreview_python_path')
        call system(printf("%s %s & 2>&1 /dev/null",
        \ shellescape(g:htmlpreview_python_path),
        \ shellescape(s:pyscript)))
      else
        call system(printf("%s & 2>&1 /dev/null", shellescape(s:pyscript)))
      endif
    endif
    sleep 1
    " FIXME: On MacOSX system() above return v:shell_error 7.
    "if v:shell_error != 0 && ((has('win32') || has('win64')) && v:shell_error != 52)
    "  echohl ErrorMsg | echomsg "fail to start 'htmlpreview.py'" | echohl None
    "  return
    "endif
    augroup HtmlPreview
      autocmd!
      autocmd BufWritePost <buffer> call <SID>update_preview()
    augroup END
  endif
  call s:update_preview()
endfunction

command! -nargs=1 SetViewerIp call SetViewerIp(<f-args>)
command! -bang HtmlPreview call <SID>htmlpreview('<bang>')
