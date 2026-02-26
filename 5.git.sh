# 标识身份
git config --global user.name "lipcoder"
git config --global user.email "you@example.com"
git config --local user.name "lipcoder"
git config --local user.email "you@example.com"

# 测试
ssh -T git@github.com

# 创建
git init                             # 创建仓库
git remote add origin git@github.com # 指向远程仓库
git push -u origin "master"          # 指向仓库的分支

# 合并
git init
git remote add origin git@github.com # 关联远程仓库
git fetch origin                     # 拉取远程仓库的所有对象
git reset --hard origin/main         # 将本地 main 分支指向远程的 main（关键一步）
git pull --set-upstream origin main  # 告诉git推到哪

# 分支
git switch main                  # 回到主分支
git switch -c feature/login      # 创建并进入新分支
git push -u origin feature/login # 将新分支上传到远程仓库
git merge --no-ff feature/login  # 把功能分支合并进来，严禁fast-forward
git merge -X theirs better/path  # 所有文件以分支为主,可以与上面合并使用

git branch        # 查看当前分支
git fetch         # 仅获取远程更新
git pull          # 获取并合并
git pull --rebase # 获取并线性整合，历史更直
git push          # 推送
git status        # 查看当前的状态
git log           # 查看历史提交的记录
