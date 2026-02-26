
#如果你想美化一下你的终端，而且可以在你进入一个初始化为git仓库的文件夹后，显示当前的分支以及其他什么的内容

# __git_ps1 是 Git 自带的一个函数，用来在提示符里显示当前目录的 Git 分支
sudo pacman -S git bash-completion

vim .bashrc

# 有这个可以解决显示不了并且报错的麻烦
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
fi

source ~/sh/powerbash.sh

# powerbash.sh在附件文件夹里面