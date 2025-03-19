#!/bin/bash
set -e  # 发生错误时终止脚本

# 设置变量
SOURCE_DIR="/var/lib/jenkins/workspace/my-python-webapp"  # Jenkins 工作目录
TARGET_DIR="/opt/my-python-webapp"

# 确保目标目录存在
if [ ! -d "${TARGET_DIR}" ]; then
    echo "目标目录不存在，正在创建..."
    sudo mkdir -p ${TARGET_DIR}
    sudo chown jenkins:jenkins ${TARGET_DIR}
fi

# 停止当前服务
echo "正在停止服务..."
sudo systemctl stop my-python-webapp || true  # 避免服务未运行时报错

# 复制新版本代码
echo "复制新代码..."
rsync -av --exclude 'config/' ${SOURCE_DIR}/ ${TARGET_DIR}/

# 切换到目标目录
cd ${TARGET_DIR} || exit 1

# 安装 Python 依赖
echo "安装依赖..."
python3 -m pip install --no-cache-dir -r requirements.txt

# 确保 systemd 服务文件存在
if [ ! -f "/etc/systemd/system/my-python-webapp.service" ]; then
    echo "创建 systemd 服务..."
    sudo bash -c 'cat > /etc/systemd/system/my-python-webapp.service <<EOF
[Unit]
Description=My Python Web App
After=network.target

[Service]
User=jenkins
Group=jenkins
WorkingDirectory=/opt/my-python-webapp
ExecStart=/usr/bin/python3 /opt/my-python-webapp/src/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF'
    sudo systemctl daemon-reload
    sudo systemctl enable my-python-webapp.service
fi

# 启动服务
echo "启动服务..."
sudo systemctl restart my-python-webapp.service
