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

# 安装依赖
print_message $BLUE "正在安装依赖..."
source install_dependencies.sh
if [ $? -ne 0 ]; then
    print_message $RED "安装依赖失败"
    exit 1
fi
print_message $GREEN "依赖安装成功"

# 软件列表
software_list=(
    "btop"
    "duf"
    "dust"
    "lsd"
)

# 显示软件列表
print_message $YELLOW "请选择要安装的软件 (直接回车表示全部安装):"
for i in "${!software_list[@]}"; do
    echo "$((i+1)). ${software_list[$i]}"
done
read -p "输入编号 (例如: 1 2 3 或直接回车): " user_choice

# 将用户输入转换为数组
if [ -z "$user_choice" ]; then
    # 用户直接回车, 安装全部软件
    selected_software=("${software_list[@]}")
else
    # 根据用户输入筛选需要安装的软件
    selected_software=()
    for choice in $user_choice; do
        if [[ $choice =~ ^[0-9]+$ ]] && [ $choice -ge 1 ] && [ $choice -le ${#software_list[@]} ]; then
            selected_software+=("${software_list[$((choice-1))]}")
        else
            print_message $RED "无效的选择: $choice"
            exit 1
        fi
    done
fi

# 安装选择的软件
for software in "${selected_software[@]}"; do
    script="install_${software}.sh"
    if [ -f "$script" ]; then
        print_message $BLUE "正在安装 $software ..."
        source "$script"
        if [ $? -ne 0 ]; then
            print_message $RED "$software 安装失败"
            exit 1
        fi
        print_message $GREEN "$software 安装成功"
    else
        print_message $RED "找不到安装脚本: $script"
        exit 1
    fi
done

print_message $GREEN "所有软件安装完成"
