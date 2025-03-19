#!/bin/bash

# 设置变量
SOURCE_DIR="/var/lib/jenkins/workspace/my-python-webapp"  # 使用 Jenkins 工作目录
TARGET_DIR="/opt/my-python-webapp"

# 确保 /opt/my-python-webapp 目录存在
if [ ! -d "${TARGET_DIR}" ]; then
    echo "目标目录不存在，正在创建..."
    sudo mkdir -p ${TARGET_DIR}
    sudo chown jenkins:jenkins ${TARGET_DIR}
fi

# 停止当前运行的服务（避免 sudo 问题）
echo "正在停止服务..."
echo "root" | sudo -S systemctl stop my-python-webapp

# 复制新版本代码到部署目录（保留已有配置文件）
echo "复制新代码..."
rsync -av --exclude 'config/' ${SOURCE_DIR}/ ${TARGET_DIR}/

# 切换到目标目录
cd ${TARGET_DIR} || exit 1

# 安装 Python 依赖
echo "安装依赖..."
python3 -m pip install --no-cache-dir -r requirements.txt

# 启动服务
echo "启动服务..."
echo "root" | sudo -S systemctl start my-python-webapp
