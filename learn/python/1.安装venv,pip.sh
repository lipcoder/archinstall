
# 安装python虚拟环境相关的东西
sudo apt install python3 python3-venv python3-pip

python -m venv .venv

source .venv/bin/activate

deactivate

# 自动进入虚拟环境

sudo pacman -S direnv

echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc

echo 'source .venv/bin/activate' > .envrc # 项目文件夹下运行这个

direnv allow

# 控制python的版本
sudo pacman -S pyenv

pyenv local 3.12.7

vim ~/.bashrc

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

source ~/.bashrc

# 在命令行在虚拟环境，然后安装了代码需要的包，但是发现代码里面导入包的那部分始终在报错，可能是解释器的原因

# 很多人是这里踩坑：
# 你在命令行里装了包，但 VS Code 里选择的是另一个解释器/虚拟环境，所以它找不到这些库。

# 检查一下：

# 看 VS Code 右下角蓝色状态栏，显示的是哪个 Python，比如 Python 3.10 (venv)。

# 按 Ctrl+Shift+P → 输入 Python: Select Interpreter → 选中你真正装了包的那个解释器。

# ======================================================================控制版本然后创建虚拟环境===========================================================================
pyenv local 3.12.7

python -m venv .venv
source .venv/bin/activate

echo 'source .venv/bin/activate' > .envrc

direnv allow
