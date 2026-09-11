"---------------------------------------------------------------------------
" Commit message helper: diff appending + explicit completion via copilot.vim
"---------------------------------------------------------------------------

" Configuration
let g:commit_diff_max_lines =
      \ get(g:, 'commit_diff_max_lines', 500)
let g:commit_diff_max_line_width =
      \ get(g:, 'commit_diff_max_line_width', 120)
let g:commit_diff_max_lines_per_file =
      \ get(g:, 'commit_diff_max_lines_per_file', 50)
let g:commit_message_skill_path =
      \ get(g:, 'commit_message_skill_path',
      \   expand('~/.copilot/skills/commit-message/SKILL.md'))
let g:commit_msg_auto_complete =
      \ get(g:, 'commit_msg_auto_complete', 1)
let g:commit_msg_completion_timeout =
      \ get(g:, 'commit_msg_completion_timeout', 30000)

let s:diff_exclude_patterns = [
      \ '*.lock',
      \ '*-lock.json',
      \ 'package-lock.json',
      \ 'yarn.lock',
      \ 'Pipfile.lock',
      \ 'poetry.lock',
      \ 'Cargo.lock',
      \ 'go.sum',
      \ ]

if !exists('s:commit_msg_requests')
  let s:commit_msg_requests = {}
endif

function s:append_diff() abort
  let git_dir = FugitiveGitDir()
  let git_root = fnamemodify(git_dir, ':h')
  let lines = [
        \ '# Write a concise English commit message for the staged changes below.',
        \ '# Subject: one sentence, 72 characters or fewer.',
        \ '# Optional body: explain WHY in 1-3 sentences after a blank line.',
        \ '# Output only the message, without markdown fences or trailers.',
        \ '#',
        \ ]

  " --- Commit Message Guidelines (from SKILL.md) ---
  let skill_path = expand(g:commit_message_skill_path)
  if filereadable(skill_path)
    call add(lines, '# --- Commit Message Guidelines ---')
    for l in readfile(skill_path)
      call add(lines, '# ' . l)
    endfor
    call add(lines, '#')
  endif

  " --- Staged Changes Summary (diffstat for all files) ---
  let stat = system('git -C ' . shellescape(git_root)
        \ . ' diff --cached --stat')
  if v:shell_error == 0 && !empty(trim(stat))
    call add(lines, '# --- Staged Changes Summary ---')
    for l in split(stat, '\n')
      call add(lines, '# ' . l)
    endfor
  endif

  " Build exclude args
  let exclude_args = ''
  for pat in s:diff_exclude_patterns
    let exclude_args .= ' ' . shellescape(':(exclude)' . pat)
  endfor

  " Detect excluded files
  let all_files = split(system('git -C ' . shellescape(git_root)
        \ . ' diff --cached --name-only'), '\n')
  let filtered_files = split(system('git -C ' . shellescape(git_root)
        \ . ' diff --cached --name-only -- .' . exclude_args), '\n')
  let excluded = filter(copy(all_files),
        \ {_, f -> index(filtered_files, f) == -1})
  if !empty(excluded)
    call add(lines, '# (excluded from diff details: '
          \ . join(excluded, ', ') . ')')
  endif

  " --- Diff Details (with per-file truncation) ---
  let diff = system('git -C ' . shellescape(git_root)
        \ . ' diff --cached -- .' . exclude_args)
  if v:shell_error == 0 && !empty(trim(diff))
    call add(lines, '#')
    call add(lines, '# --- Diff Details (truncated) ---')

    let max_w = g:commit_diff_max_line_width
    let max_pf = g:commit_diff_max_lines_per_file
    let file_count = 0
    let file_truncated = 0

    for dline in split(diff, '\n')
      if dline =~# '^diff --git '
        if file_truncated > 0
          call add(lines, '# ... (' . file_truncated . ' lines truncated)')
        endif
        let file_count = 0
        let file_truncated = 0
      endif

      if dline =~# '^Binary files '
        call add(lines, '# ' . dline)
        continue
      endif

      if file_count >= max_pf
        let file_truncated += 1
        continue
      endif

      " Truncate long lines
      if len(dline) > max_w
        let dline = dline[: max_w - 4] . '...'
      endif

      call add(lines, '# ' . dline)
      let file_count += 1
    endfor

    if file_truncated > 0
      call add(lines, '# ... (' . file_truncated . ' lines truncated)')
    endif
  endif

  " Apply total line limit
  let max_total = g:commit_diff_max_lines
  if len(lines) > max_total
    let lines = lines[: max_total - 2]
    call add(lines, '# ... (output truncated at ' . max_total . ' lines)')
  endif

  call append(line('$'), lines)

  if g:commit_msg_auto_complete
    call s:generate_commit_msg()
  endif
endfunction

function s:commit_msg_notice(message, highlight) abort
  redraw
  execute 'echohl ' . a:highlight
  echomsg '[CommitMsg] ' . a:message
  echohl None
endfunction

function s:commit_msg_pending(state) abort
  return get(s:commit_msg_requests, a:state.bufnr, {}) is a:state
endfunction

function s:finish_commit_msg(state) abort
  if !s:commit_msg_pending(a:state)
    return 0
  endif
  call remove(s:commit_msg_requests, a:state.bufnr)
  call timer_stop(a:state.timer)
  if !empty(a:state.request)
    call a:state.request.Cancel()
  endif
  if a:state.prompt_bufnr > 0 && bufexists(a:state.prompt_bufnr)
    execute 'silent bwipeout! ' . a:state.prompt_bufnr
  endif
  return 1
endfunction

function s:commit_msg_unchanged(state) abort
  return bufloaded(a:state.bufnr)
        \ && getbufvar(a:state.bufnr, 'changedtick') == a:state.changedtick
        \ && getbufvar(a:state.bufnr, '&modifiable')
        \ && !getbufvar(a:state.bufnr, '&readonly')
endfunction

function s:generate_commit_msg() abort
  call s:cancel_commit_msg(bufnr(''))
  let state = {
        \ 'bufnr': bufnr(''),
        \ 'prompt_bufnr': -1,
        \ 'request': {},
        \ 'timer': -1,
        \ }
  let s:commit_msg_requests[state.bufnr] = state
  " Defer until startup autocommands and filetype setup have finished.
  let state.timer = timer_start(0, function('s:start_commit_msg', [state]))
endfunction

function s:prepare_commit_msg_prompt(state) abort
  let context = map(getbufline(a:state.bufnr, 2, '$'),
        \ {_, line -> substitute(line, '^# \?', '', '')})
  let lines = context + ['', 'Commit message (plain text, without fences or trailers):', '']
  " A prose prompt avoids copying the original gitcommit buffer as a similar file.
  let prompt_bufnr = bufadd(tempname() . '.md')
  let a:state.prompt_bufnr = prompt_bufnr
  if prompt_bufnr <= 0
    call s:finish_commit_msg(a:state)
    call s:commit_msg_notice('Failed to create the completion context buffer.', 'ErrorMsg')
    return 0
  endif
  call setbufvar(prompt_bufnr, '&buftype', 'nofile')
  call setbufvar(prompt_bufnr, '&bufhidden', 'hide')
  call setbufvar(prompt_bufnr, '&swapfile', 0)
  call setbufvar(prompt_bufnr, '&undofile', 0)
  noautocmd call bufload(prompt_bufnr)
  noautocmd call setbufvar(prompt_bufnr, '&filetype', 'markdown')
  let workspace = getbufvar(a:state.bufnr, 'workspace_folder', '')
  if !empty(workspace)
    call setbufvar(prompt_bufnr, 'workspace_folder', workspace)
  endif
  if setbufline(prompt_bufnr, 1, lines) != 0
    call s:finish_commit_msg(a:state)
    call s:commit_msg_notice('Failed to populate the completion context buffer.', 'ErrorMsg')
    return 0
  endif
  let a:state.position = {'line': len(lines) - 1, 'character': 0}
  return 1
endfunction

function s:start_commit_msg(state, timer) abort
  if !s:commit_msg_pending(a:state)
    return
  endif
  if !bufloaded(a:state.bufnr) || bufnr('') != a:state.bufnr
        \ || !&modifiable || &readonly
    call s:cancel_commit_msg(a:state.bufnr)
    return
  endif
  " Never replace an existing message, including a body below an empty subject.
  if &filetype !=# 'gitcommit' || getline(1) !=# ''
        \ || !empty(filter(getline(1, '$'), 'v:val !~# ''^\s*\%($\|#\)'''))
    call s:finish_commit_msg(a:state)
    call s:commit_msg_notice('Skipped: an empty gitcommit message is required.', 'WarningMsg')
    return
  endif
  try
    if !copilot#Enabled()
      call s:finish_commit_msg(a:state)
      call s:commit_msg_notice('Copilot is disabled for this buffer.', 'WarningMsg')
      return
    endif
    if !s:prepare_commit_msg_prompt(a:state)
      return
    endif
    let params = {
          \ 'textDocument': {'uri': a:state.prompt_bufnr},
          \ 'position': a:state.position,
          \ }
    " Inline suggestions can be empty for valid commit prompts; request explicit
    " candidates as :Copilot panel does, without opening a panel window.
    " copilot.vim queues the request until its language server is initialized.
    let a:state.changedtick = b:changedtick
    let a:state.request = copilot#Request('textDocument/copilotPanelCompletion', params,
          \ function('s:on_commit_msg_result', [a:state]),
          \ function('s:on_commit_msg_error', [a:state]))
  catch /\<E117:/
    call s:finish_commit_msg(a:state)
    call s:commit_msg_notice('copilot.vim completion API is unavailable: ' . v:exception, 'ErrorMsg')
    return
  endtry
  let a:state.timer = timer_start(g:commit_msg_completion_timeout,
        \ function('s:on_commit_msg_timeout', [a:state]))
  call s:commit_msg_notice('Completing... (:CancelCommitMsg to cancel)', 'MoreMsg')
endfunction

function s:on_commit_msg_error(state, error) abort
  if s:finish_commit_msg(a:state)
    call s:commit_msg_notice('Completion failed: ' . get(a:error, 'message', string(a:error)), 'ErrorMsg')
  endif
endfunction

function s:on_commit_msg_timeout(state, timer) abort
  if s:finish_commit_msg(a:state)
    call s:commit_msg_notice('Completion timed out; no CLI fallback was used.', 'WarningMsg')
  endif
endfunction

function s:on_commit_msg_result(state, result) abort
  if !s:finish_commit_msg(a:state)
    return
  endif
  if !s:commit_msg_unchanged(a:state)
    call s:commit_msg_notice('Completion discarded: buffer changed or closed.', 'WarningMsg')
    return
  endif
  let items = type(a:result) == v:t_list ? a:result
        \ : (type(a:result) == v:t_dict ? get(a:result, 'items', []) : [])
  if empty(items)
    call s:commit_msg_notice('No completion candidate was returned.', 'WarningMsg')
    return
  endif
  let item = items[0]
  let origin = a:state.position
  let range = get(item, 'range', {'start': origin, 'end': origin})
  if range.start !=# origin || range.end !=# origin
    call s:commit_msg_notice('Unsupported completion range; buffer left unchanged.', 'ErrorMsg')
    return
  endif
  if type(get(item, 'insertText', v:null)) != v:t_string
    call s:commit_msg_notice('Unsupported completion text; buffer left unchanged.', 'ErrorMsg')
    return
  endif
  let lines = split(s:sanitize_commit_msg(item.insertText), '\n')
  if empty(lines)
    call s:commit_msg_notice('Generated message was empty after sanitization.', 'WarningMsg')
    return
  endif
  " Keep the original blank first line as the separator, without switching buffers.
  let view = bufnr('') == a:state.bufnr ? winsaveview() : {}
  if appendbufline(a:state.bufnr, 0, lines) != 0
    call s:commit_msg_notice('Failed to insert the completion.', 'ErrorMsg')
    return
  endif
  if !empty(view)
    " Keep a cursor in the message slot there; preserve comment positions below it.
    if view.lnum > 1
      let view.lnum += len(lines)
    endif
    if view.topline > 1
      let view.topline += len(lines)
    endif
    call winrestview(view)
  endif
  if has_key(item, 'command')
    call copilot#Request('workspace/executeCommand', item.command)
  endif
  call s:commit_msg_notice('Commit message completed.', 'MoreMsg')
endfunction

function s:sanitize_commit_msg(msg) abort
  let lines = split(substitute(a:msg, '\r\n\=', '\n', 'g'), '\n')
  let result = []

  " Do not insert Git's comment template if the model continues into it.
  for l in lines
    if l =~# '^\s*#'
      break
    endif
    if l =~# '^```'
      continue
    endif
    call add(result, l)
  endfor
  let lines = result

  " Remove prohibited trailers and metadata
  let result = []
  for l in lines
    if l =~# '^\s*Co-authored-by:'
      continue
    endif
    if l =~# '^\s*Signed-off-by:'
      continue
    endif
    call add(result, l)
  endfor
  let lines = result

  " Remove leading/trailing blank lines
  while !empty(lines) && empty(trim(lines[0]))
    call remove(lines, 0)
  endwhile
  while !empty(lines) && empty(trim(lines[-1]))
    call remove(lines, -1)
  endwhile

  " Enforce 72-char line width (wrap body lines, truncate subject)
  let result = []
  for i in range(len(lines))
    let l = lines[i]
    if i == 0
      " Subject line: hard truncate at 72 chars
      if len(l) > 72
        let l = l[:71]
      endif
      call add(result, l)
    elseif empty(trim(l))
      call add(result, '')
    else
      " Body lines: word-wrap at 72 chars
      while len(l) > 72
        let break_at = strridx(l[:71], ' ')
        if break_at <= 0
          let break_at = 72
        endif
        call add(result, l[:break_at - 1])
        let l = trim(l[break_at:])
      endwhile
      if !empty(l)
        call add(result, l)
      endif
    endif
  endfor
  let lines = result

  return join(lines, "\n")
endfunction


function s:cancel_commit_msg(bufnr) abort
  if has_key(s:commit_msg_requests, a:bufnr)
    call s:finish_commit_msg(s:commit_msg_requests[a:bufnr])
    call s:commit_msg_notice('Completion cancelled.', 'WarningMsg')
  endif
endfunction

command! GenerateCommitMsg call s:generate_commit_msg()
command! CancelCommitMsg call s:cancel_commit_msg(bufnr(''))

augroup CommitMessage
  autocmd!
  autocmd BufReadPost COMMIT_EDITMSG call s:append_diff()
  autocmd BufUnload * call s:cancel_commit_msg(str2nr(expand('<abuf>')))
augroup END
