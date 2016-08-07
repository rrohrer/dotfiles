brew install cmake cscope ctags macvim the_silver_searcher wget
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.ctags ~/.ctags
ln -s ~/dotfiles/.bash_profile ~/.bash_profile
vim +PlugInstall +qall
