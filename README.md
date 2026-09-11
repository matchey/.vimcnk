# .vimcnk

1. Run below script.
    ```
    ~$ cd ~/.vimcnk/rc/plugins
    ~$ sh ./installer.sh .
    ```
    Note: If you use Vim 7.4, please use dein.vim ver.1.5 instead.  
    ```
    ~$ cd ~/.vimcnk/rc/plugins/repos/github.com/Shougo/dein.vim
    ~$ git checkout 1.5
    ```
    <!-- 1. Make undo directory for perpetuation undo -->
    <!-- 	``` -->
    <!-- 	~$ mkdir ~/.vimcnk/.vimundo -->
    <!-- 	``` -->
1. Edit your .vimrc
    ```
    ~$ sed -i '1isource ~/.vimcnk/vimrc' ~/.vimrc
    ```
	or (if [ ! -e ~/.vimrc ]; then)
    ```
    ~$ echo "source ~/.vimcnk/vimrc" > ~/.vimrc
    ```
1. Open vim and install dein
    ```vim
    :call dein#install()
    ```

## Commit message completion

Opening `COMMIT_EDITMSG` appends staged changes and commit guidelines as
comments, then requests explicit completions through `copilot.vim`, using the
same endpoint as `:Copilot panel` without opening a panel window. The first
candidate is inserted automatically only while the message buffer is still
empty and unchanged. Existing messages and edits made while waiting are
preserved.

Completion uses a hidden, memory-only Markdown buffer. Git comment prefixes
are removed from the copied context, and the guidelines and diff precede an
explicit message output section. Only the returned message is inserted at the
top of the original buffer; its comment layout is unchanged. The temporary
buffer is discarded on completion, error, timeout, or cancellation.

This does not run Copilot CLI or fall back to it. Under GitHub's current billing
policy, code completions do not consume AI Credits. A completion may
return no candidate; errors and timeouts are reported without inserting text.
Copilot must be authenticated and enabled for `gitcommit`.

`g:commit_msg_auto_complete` controls automatic completion (default: `1`);
set it to `0` to keep only the appended context. It replaces the old
CLI-specific `g:commit_msg_auto_generate` setting.
`g:commit_msg_completion_timeout` controls the timeout in milliseconds
(default: `30000`).

`:GenerateCommitMsg` requests a completion for the current empty commit
message, and `:CancelCommitMsg` cancels its pending request. Both use only
`copilot.vim`. The integration depends on the plugin's
`copilot#Request()` API and `textDocument/copilotPanelCompletion` response format.
The inline-suggestion endpoint is not used: it can return no candidates for a
commit prompt even when the explicit-completion endpoint returns candidates.

The offline regression tests use Vim's built-in assertions and a fake
completion provider; they do not call Copilot:

```sh
vim -Nu NONE -i NONE -n -es -S tests/commit_msg.vim
```
