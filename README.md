# .vimcnk

1. Run below script.

     ```
     ~$ cd ~/.vimcnk/rc/plugins
     ~$ sh ./installer.sh .
     ```

2. Edit your .vimrc
	```
	~$ echo "source ~/.vimcnk/vimrc" >> .vimrc
	```
3. Open vim and install dein

    ```vim
    :call dein#install()
    ```

