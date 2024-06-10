#!/bin/bash

# 定义依赖库集合
DEPENDENCIES=("curl" "git" "wget" "make")

# 检测操作系统类型
if [ -f /etc/debian_version ]; then
    OS="Debian"
    INSTALL_CMD="sudo apt-get install -y"
    CHECK_CMD="command -v"
elif [ -f /etc/redhat-release ]; then
    OS="RedHat"
    INSTALL_CMD="sudo yum install -y"
    CHECK_CMD="command -v"
else
    echo "不支持的操作系统类型"
    exit 1
fi

echo "检测到操作系统：$OS 系"

# 安装依赖库
for DEP in "${DEPENDENCIES[@]}"; do
    echo "检查 $DEP 是否已安装..."
    if $CHECK_CMD $DEP &>/dev/null; then
        echo "$DEP 已安装"
    else
        echo "$DEP 未安装。正在安装 $DEP..."
        $INSTALL_CMD $DEP
        if [ $? -eq 0 ]; then
            echo "$DEP 安装成功"
        else
            echo "安装 $DEP 失败"
            exit 1
        fi
    fi
done

echo "所有依赖库已检查并在必要时安装完毕。"

