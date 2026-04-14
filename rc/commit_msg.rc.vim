"---------------------------------------------------------------------------
" Commit message helper: diff appending + auto-generation via Copilot CLI
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
let g:commit_msg_auto_generate =
      \ get(g:, 'commit_msg_auto_generate', 1)

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

let s:commit_msg_job = v:null

function s:append_diff() abort
  let git_dir = FugitiveGitDir()
  let git_root = fnamemodify(git_dir, ':h')
  let lines = []

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

  " Auto-generate commit message
  if g:commit_msg_auto_generate
    call s:generate_commit_msg(git_root)
  endif
endfunction

function s:generate_commit_msg(git_root) abort
  call s:cancel_commit_msg_job()

  " Build the prompt with SKILL.md rules + strict instructions
  let prompt_parts = []
  call add(prompt_parts, 'Generate a git commit message for the staged changes below.')
  call add(prompt_parts, '')
  call add(prompt_parts, '=== STRICT OUTPUT RULES ===')
  call add(prompt_parts, '- Output ONLY the raw commit message text. Nothing else.')
  call add(prompt_parts, '- Do NOT wrap in markdown code blocks or quotes.')
  call add(prompt_parts, '- Do NOT add Co-authored-by, Signed-off-by, or any trailers.')
  call add(prompt_parts, '- Do NOT add bullet-point lists of changed files or functions.')
  call add(prompt_parts, '- Write in English.')
  call add(prompt_parts, '- Subject: single short sentence, 72 chars or fewer.')
  call add(prompt_parts, '- Body (optional): 1-3 sentences max. Write WHY, not WHAT.')
  call add(prompt_parts, '- Separate subject and body with a blank line.')
  call add(prompt_parts, '')

  let skill_path = expand(g:commit_message_skill_path)
  if filereadable(skill_path)
    call add(prompt_parts, '=== DETAILED COMMIT MESSAGE GUIDELINES ===')
    call add(prompt_parts, join(readfile(skill_path), "\n"))
    call add(prompt_parts, '')
  endif

  call add(prompt_parts, '=== DIFF ===')

  let diff_for_prompt = system('git -C ' . shellescape(a:git_root)
        \ . ' diff --cached --stat')
  let diff_for_prompt .= "\n"
  let diff_for_prompt .= system('git -C ' . shellescape(a:git_root)
        \ . ' diff --cached')
  let diff_lines = split(diff_for_prompt, '\n')
  if len(diff_lines) > 300
    let diff_for_prompt = join(diff_lines[:299], "\n")
          \ . "\n... (diff truncated)"
  endif
  call add(prompt_parts, diff_for_prompt)

  call add(prompt_parts, '')
  call add(prompt_parts, 'Remember: output ONLY the commit message. No trailers. No markdown fences. Be concise.')

  let prompt = join(prompt_parts, "\n")

  let tmpfile = tempname()
  call writefile(split(prompt, '\n'), tmpfile)

  " Show indicator in command line (deferred to avoid "Press ENTER" prompt)
  call timer_start(0, {-> execute(
        \ "redraw | echohl MoreMsg | echon '[CommitMsg] Generating... (:CancelCommitMsg to cancel)' | echohl None",
        \ '')})

  let s:commit_msg_job = job_start(
        \ ['sh', '-c', 'copilot -p "$(cat ' . shellescape(tmpfile) . ')" 2>/dev/null; rm -f ' . shellescape(tmpfile)],
        \ #{
        \   out_cb: function('s:on_commit_msg_stdout'),
        \   close_cb: function('s:on_commit_msg_close'),
        \   out_mode: 'raw',
        \ })
  let s:commit_msg_output = ''
  let s:commit_msg_bufnr = bufnr('%')
endfunction

function s:on_commit_msg_stdout(ch, msg) abort
  let s:commit_msg_output .= a:msg
endfunction

function s:on_commit_msg_close(ch) abort
  let s:commit_msg_job = v:null
  let msg = trim(s:commit_msg_output)
  if empty(msg)
    redraw
    echohl ErrorMsg
    echo '[CommitMsg] Failed to generate commit message'
    echohl None
    return
  endif

  " Post-process: sanitize the generated message
  let msg = s:sanitize_commit_msg(msg)

  let lines = split(msg, '\n')
  if empty(lines)
    redraw
    echohl ErrorMsg
    echo '[CommitMsg] Generated message was empty after sanitization'
    echohl None
    return
  endif
  " Add trailing blank line after body
  call add(lines, '')

  if bufexists(s:commit_msg_bufnr)
    let cur_buf = bufnr('%')
    let cur_win = winnr()
    let target_win = bufwinnr(s:commit_msg_bufnr)
    if target_win != -1
      execute target_win . 'wincmd w'
    else
      execute 'buffer ' . s:commit_msg_bufnr
    endif
    let save_view = winsaveview()
    if empty(trim(getline(1)))
      call setline(1, lines[0])
      if len(lines) > 1
        call append(1, lines[1:])
      endif
    endif
    call winrestview(save_view)
    if target_win != -1
      execute cur_win . 'wincmd w'
    elseif cur_buf != s:commit_msg_bufnr
      execute 'buffer ' . cur_buf
    endif
    redraw
  endif
  echohl MoreMsg
  echo '[CommitMsg] Commit message generated'
  echohl None
endfunction

function s:sanitize_commit_msg(msg) abort
  let lines = split(a:msg, '\n')
  let result = []

  " Strip markdown code fences
  let in_fence = 0
  for l in lines
    if l =~# '^```'
      let in_fence = !in_fence
      continue
    endif
    if !in_fence
      call add(result, l)
    endif
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


function s:cancel_commit_msg_job() abort
  if s:commit_msg_job isnot v:null
        \ && job_status(s:commit_msg_job) ==# 'run'
    call job_stop(s:commit_msg_job)
    let s:commit_msg_job = v:null
    redraw
    echohl WarningMsg
    echo '[CommitMsg] Generation cancelled'
    echohl None
  endif
endfunction

command! GenerateCommitMsg call s:generate_commit_msg(
      \ fnamemodify(FugitiveGitDir(), ':h'))
command! CancelCommitMsg call s:cancel_commit_msg_job()

autocmd BufReadPost COMMIT_EDITMSG call s:append_diff()
