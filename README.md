# .vimcnk

1. Run below script.
     ```
     ~$ cd ~/.vimcnk/rc/plugins
     ~$ sh ./installer.sh .
     ```
1. Make undo directory for perpetuation undo
     ```
     ~$ mkdir ~/.vimcnk/.vimundo
     ```
1. Edit your .vimrc
	```
	~$ echo "source ~/.vimcnk/vimrc" >> ~/.vimrc
	```
1. Open vim and install dein

    ```vim
    :call dein#install()
    ```

