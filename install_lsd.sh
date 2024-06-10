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

# 获取最新的发布版本
LATEST_VERSION=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | jq -r '.tag_name')
if [ -z "$LATEST_VERSION" ]; then
    print_message $RED "无法获取最新版本信息"
    exit 1
fi
print_message $BLUE "最新版本: $LATEST_VERSION"

# 检测 CPU 架构
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        FILE="lsd-${LATEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    aarch64)
        FILE="lsd-${LATEST_VERSION}-aarch64-unknown-linux-gnu.tar.gz"
        ;;
    armv7l)
        FILE="lsd-${LATEST_VERSION}-arm-unknown-linux-gnueabihf.tar.gz"
        ;;
    i686)
        FILE="lsd-${LATEST_VERSION}-i686-unknown-linux-gnu.tar.gz"
        ;;
    *)
        print_message $RED "不支持的 CPU 架构: $ARCH"
        exit 1
        ;;
esac
print_message $BLUE "检测到 CPU 架构: $ARCH"

# 下载对应架构的 lsd
URL="https://github.com/lsd-rs/lsd/releases/download/$LATEST_VERSION/$FILE"
print_message $YELLOW "下载 $URL ..."
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    print_message $RED "下载失败"
    exit 1
fi
print_message $GREEN "下载成功"

# 解压文件
print_message $YELLOW "解压 $FILE ..."
tar -xzf $FILE
if [ $? -ne 0 ]; then
    print_message $RED "解压失败"
    exit 1
fi
print_message $GREEN "解压成功"

# 安装 lsd
print_message $YELLOW "安装 lsd ..."
sudo install -m 755 lsd*/lsd /usr/local/bin/lsd
if [ $? -ne 0 ]; then
    print_message $RED "安装失败"
    exit 1
fi
print_message $GREEN "安装成功"

# 配置 zsh 别名
print_message $YELLOW "配置 zsh 别名 ..."
{
    echo "alias ls='lsd'"
    echo "alias ll='lsd -alh'"
    echo "alias tree='lsd --tree'"
} >> ~/.zshrc
if [ $? -ne 0 ]; then
    print_message $RED "配置别名失败"
    exit 1
fi
print_message $GREEN "配置别名成功"

# 使 zsh 配置生效
source ~/.zshrc
if [ $? -ne 0 ]; then
    print_message $RED "使配置生效失败"
    exit 1
fi
print_message $GREEN "配置生效成功"

# 清理文件
rm -rf lsd* $FILE
print_message $BLUE "安装完成并清理临时文件"

