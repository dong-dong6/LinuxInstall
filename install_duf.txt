#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

# 打印消息函数
print_message() {
    COLOR=$1
    MESSAGE=$2
    echo -e "${COLOR}${MESSAGE}${NC}"
}

print_message $YELLOW "更新包列表..."
sudo apt-get update

print_message $YELLOW "安装 duf..."
if sudo apt-get install -y duf; then
    print_message $GREEN "duf 安装成功！"
else
    print_message $RED "duf 安装失败，请检查您的包管理器配置。"
    exit 1
fi

