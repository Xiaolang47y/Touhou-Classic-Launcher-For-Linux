#!/bin/bash

# ============================================
# 东方Project旧作 (PC-98) Linux启动器 v2.3
# 每次启动前询问全屏/窗口模式
# ============================================

# 智能定位脚本和 dosbox-x 目录
find_dosbox_dir() {
    SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [[ "$(basename "$SCRIPT_PATH")" == "dosbox-x" ]]; then
        DOSBOX_DIR="$SCRIPT_PATH"
    elif [[ -d "$SCRIPT_PATH/dosbox-x" ]]; then
        DOSBOX_DIR="$SCRIPT_PATH/dosbox-x"
    else
        echo -e "${RED}错误: 找不到 dosbox-x 目录${NC}"
        exit 1
    fi
}

find_dosbox_dir

# 游戏列表
declare -A GAMES=(
    ["th01"]="东方灵异传 - The Highly Responsive to Prayers"
    ["th02"]="东方封魔录 - Story of Eastern Wonderland"
    ["th03"]="东方梦时空 - Phantasmagoria of Dim.Dream"
    ["th04"]="东方幻想乡 - Lotus Land Story"
    ["th05"]="东方怪绮谈 - Mystic Square"
)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 检查 dosbox-x 是否已安装
check_dosbox() {
    if ! command -v dosbox-x &> /dev/null; then
        echo -e "${RED}错误: 未找到 dosbox-x${NC}"
        return 1
    fi
    return 0
}

# 显示Banner
show_banner() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                          ║${NC}"
    echo -e "${PURPLE}║${YELLOW}      东方Project旧作 PC-98 Linux 启动器 v2.3            ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${CYAN}           Touhou Project Classic Launcher                 ${PURPLE}║${NC}"
    echo -e "${PURPLE}║                                                          ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 检查游戏可用性
check_game_available() {
    local game=$1
    local lang=$2
    if [[ -f "$DOSBOX_DIR/${game}_${lang}.conf" ]]; then
        return 0
    else
        return 1
    fi
}

# 选择语言
select_language() {
    echo -e "${GREEN}请选择游戏语言:${NC}"
    echo "  1) 中文版"
    echo "  2) 日文版"
    echo "  3) 退出"
    echo ""
    read -p "$(echo -e ${CYAN}请输入选项 [1-3]:${NC} )" lang_choice
    
    case $lang_choice in
        1) LANG_SUFFIX="cn" ;;
        2) LANG_SUFFIX="jp" ;;
        3) exit 0 ;;
        *) 
            echo -e "${RED}无效选项，请重新选择${NC}"
            sleep 1
            select_language
            ;;
    esac
}

# 选择游戏
select_game() {
    local lang=$1
    show_banner
    
    echo -e "${GREEN}当前语言: ${YELLOW}$([ "$lang" == "cn" ] && echo "中文版" || echo "日文版")${NC}"
    echo ""
    echo -e "${GREEN}请选择要游玩的游戏:${NC}"
    echo ""
    
    local available_games=()
    local game_num=1
    
    for game in th01 th02 th03 th04 th05; do
        if check_game_available "$game" "$lang"; then
            echo -e "  ${game_num}) ${GREEN}${game^^} - ${GAMES[$game]}${NC}"
            available_games+=("$game")
        else
            echo -e "  ${game_num}) ${RED}${game^^} - ${GAMES[$game]} (不可用)${NC}"
            available_games+=("")
        fi
        ((game_num++))
    done
    
    echo "  6) 切换语言"
    echo "  7) 退出"
    echo ""
    
    read -p "$(echo -e ${CYAN}请输入选项 [1-7]:${NC} )" game_choice
    
    case $game_choice in
        1|2|3|4|5) 
            GAME_ID="${available_games[$game_choice-1]}"
            if [[ -z "$GAME_ID" ]]; then
                echo -e "${RED}该游戏在此语言版本下不可用！${NC}"
                sleep 2
                return 1
            fi
            return 0
            ;;
        6) return 2 ;;  # 切换语言
        7) exit 0 ;;
        *) 
            echo -e "${RED}无效选项，请重新选择${NC}"
            sleep 1
            return 1
            ;;
    esac
}

# 启动游戏
launch_game() {
    local conf_file="$DOSBOX_DIR/${GAME_ID}_${LANG_SUFFIX}.conf"
    local hdi_file=""
    
    # 根据语言选择对应的HDI文件
    if [[ "$LANG_SUFFIX" == "cn" ]]; then
        hdi_file="$DOSBOX_DIR/cn.hdi"
    else
        hdi_file="$DOSBOX_DIR/jp.hdi"
    fi
    
    # 检查HDI文件是否存在
    if [[ ! -f "$hdi_file" ]]; then
        echo -e "${RED}错误: HDI镜像文件不存在: $hdi_file${NC}"
        sleep 2
        return 1
    fi
    
    clear
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  正在启动游戏...${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "游戏: ${YELLOW}${GAMES[$GAME_ID]}${NC}"
    echo -e "语言: ${YELLOW}$([ "$LANG_SUFFIX" == "cn" ] && echo "中文版" || echo "日文版")${NC}"
    echo ""
    echo -e "${CYAN}提示:${NC}"
    echo -e "  • 全屏模式按 F11 或 Alt+Enter 切换"
    echo -e "  • 窗口模式下可用鼠标拖动调整大小"
    echo ""
    
    # 询问是否全屏启动
    echo -e "${YELLOW}----------------------------------------${NC}"
    read -p "$(echo -e ${CYAN}是否以全屏模式启动？[Y/n]${NC} )" -n 1 -r
    echo ""
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    cd "$DOSBOX_DIR"
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${GREEN}以窗口模式启动...${NC}"
        sleep 1
        dosbox-x -conf "${GAME_ID}_${LANG_SUFFIX}.conf"
    else
        echo -e "${GREEN}以全屏模式启动...${NC}"
        sleep 1
        dosbox-x -conf "${GAME_ID}_${LANG_SUFFIX}.conf" -fullscreen
    fi
    
    cd - > /dev/null
}

# 主函数
main() {
    if ! check_dosbox; then
        exit 1
    fi
    
    # 主循环
    while true; do
        show_banner
        select_language
        
        while true; do
            select_result=1
            while [[ $select_result -eq 1 ]]; do
                select_game "$LANG_SUFFIX"
                select_result=$?
            done
            
            if [[ $select_result -eq 2 ]]; then
                break  # 返回语言选择
            fi
            
            launch_game
            
            echo ""
            read -p "按 Enter 继续..."
        done
    done
}

# 运行主函数
main
