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
LATEST_VERSION=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest | jq -r '.tag_name')
if [ -z "$LATEST_VERSION" ]; then
    print_message $RED "无法获取最新版本信息"
    exit 1
fi
print_message $BLUE "最新版本: $LATEST_VERSION"

# 检测 CPU 架构
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        FILE="dust-${LATEST_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    aarch64)
        FILE="dust-${LATEST_VERSION}-aarch64-unknown-linux-gnu.tar.gz"
        ;;
    armv7l)
        FILE="dust-${LATEST_VERSION}-arm-unknown-linux-musleabi.tar.gz"
        ;;
    i686)
        FILE="dust-${LATEST_VERSION}-i686-unknown-linux-gnu.tar.gz"
        ;;
    *)
        print_message $RED "不支持的 CPU 架构: $ARCH"
        exit 1
        ;;
esac
print_message $BLUE "检测到 CPU 架构: $ARCH"

# 下载对应架构的 dust
URL="https://github.com/bootandy/dust/releases/download/$LATEST_VERSION/$FILE"
print_message $YELLOW "下载 $URL ..."
wget $URL -O $FILE
if [ $? -ne 0 ]; then
    print_message $RED "下载失败"
    exit 1
fi
print_message $GREEN "下载成功"

# 解压文件
print_message $YELLOW "解压 $FILE ..."
tar -xvf $FILE
if [ $? -ne 0 ]; then
    print_message $RED "解压失败"
    exit 1
fi
print_message $GREEN "解压成功"

# 移动二进制文件到 /usr/local/bin/
DIR_NAME=$(basename $FILE .tar.gz)
cd $DIR_NAME || { print_message $RED "进入目录失败"; exit 1; }
print_message $YELLOW "移动 dust 二进制文件到 /usr/local/bin/ ..."
sudo mv dust /usr/local/bin/
if [ $? -ne 0 ]; then
    print_message $RED "移动文件失败"
    exit 1
fi
print_message $GREEN "移动文件成功"

# 清理文件
cd ..
rm -rf $DIR_NAME $FILE
print_message $BLUE "安装完成并清理临时文件"

