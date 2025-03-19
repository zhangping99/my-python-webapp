#!/bin/bash
# 停止当前运行的服务
sudo systemctl stop my-python-webapp

# 复制新版本代码到部署目录
# 注意：Jenkins 的工作目录通常是 /var/lib/jenkins/workspace/<job-name>
# 如果 Jenkins 运行在 WSL 中，需要将 Windows 路径转换为 WSL 路径
SOURCE_DIR="/mnt/d/workspace_pycharm/my-python-webapp"  # Windows 路径转换为 WSL 路径
TARGET_DIR="/opt/my-python-webapp"

# 清空目标目录并复制新代码
sudo rm -rf ${TARGET_DIR}/*
sudo cp -r ${SOURCE_DIR}/* ${TARGET_DIR}/

# 安装依赖
cd ${TARGET_DIR}
python3 -m pip install -r requirements.txt

# 启动服务
sudo systemctl start my-python-webapp