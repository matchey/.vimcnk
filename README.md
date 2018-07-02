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
1. Make undo directory for perpetuation undo
     ```
     ~$ mkdir ~/.vimcnk/.vimundo
     ```
1. Edit your .vimrc
	<!-- ~$ echo "source ~/.vimcnk/vimrc" >> ~/.vimrc -->
	```
	~$ sed -i '1isource ~/.vimcnk/vimrc' ~/.vimrc
	```
1. Open vim and install dein

    ```vim
    :call dein#install()
    ```

