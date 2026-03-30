# ollama 客户端通过环境变量 OLLAMA_HOST 来知道要连接哪个服务端
# 服务端参照下面的命令
# OLLAMA_HOST=0.0.0.0:11434 ollama serve
export OLLAMA_HOST=http://192.168.1.178:11434

ollama rm mox
ollama pull mox
ollama run mox