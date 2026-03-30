# 安装python，以及direnv自动进入进出虚拟环境，还有控制python版本
sudo pacman -S python python-pip direnv pyenv

# 手动版本
# python -m venv .venv                     #创建虚拟环境
# source .venv/bin/activate                #激活这个虚拟环境
# deactivate                               #退出虚拟环境

# 控制python版本
# pyenv install -s 3.14.3                  #下载特定版本
# pyenv local 3.12.7                       #在当前目录写入.python-version
cat >>~/.bashrc <<'EOF'
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF

# 自动进入进出虚拟环境
# echo 'source .venv/bin/activate' >.envrc #在当前目录生成.envrc
# direnv allow                             #授权direnv使用.envrc,完成后可自动进出
cat >>~/.bashrc <<'EOF'
# python虚拟环境
eval "$(direnv hook bash)" 
EOF

source ~/.bashrc

# 在命令行在虚拟环境，然后安装了代码需要的包，但是发现代码里面导入包的那部分始终在报错，可能是解释器的原因
# 很多人是这里踩坑：你在命令行里装了包，但 VS Code 里选择的是另一个解释器/虚拟环境，所以它找不到这些库
# 检查一下：看 VS Code 右下角蓝色状态栏，显示的是哪个 Python，比如 Python 3.10 (venv)
# 按 Ctrl+Shift+P → 输入 Python: Select Interpreter → 选中你真正装了包的那个解释器
