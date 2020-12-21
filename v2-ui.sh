#!/bin/sh

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

confirm() {
    if [[ $# > 1 ]]; then
        echo && read -p "$1 [默认$2]: " temp
        if [[ x"${temp}" == x"" ]]; then
            temp=$2
        fi
    else
        read -p "$1 [y/n]: " temp
    fi
    if [[ x"${temp}" == x"y" || x"${temp}" == x"Y" ]]; then
        return 0
    else
        return 1
    fi
}

confirm_restart() {
    confirm "是否重启面板，重启面板也会重启 v2ray" "y"
    if [[ $? == 0 ]]; then
        restart
    else
        show_menu
    fi
}

before_show_menu() {
    echo && echo -n -e "${yellow}按回车返回主菜单: ${plain}" && read temp
    show_menu
}

reset_user() {
    confirm "确定要将用户名和密码重置为 admin 吗" "n"
    if [[ $? != 0 ]]; then
        if [[ $# == 0 ]]; then
            show_menu
        fi
        return 0
    fi
    python3 /usr/local/v2-ui/v2-ui.py resetuser &
    sleep 3
    echo -e "用户名和密码已重置为 ${green}admin${plain}，现在请重启面板"
    confirm_restart
}

reset_config() {
    confirm "确定要重置所有面板设置吗，账号数据不会丢失，用户名和密码不会改变" "n"
    if [[ $? != 0 ]]; then
        if [[ $# == 0 ]]; then
            show_menu
        fi
        return 0
    fi
    python3 /usr/local/v2-ui/v2-ui.py resetconfig &
    sleep 3
    echo -e "所有面板已重置为默认值，现在请重启面板，并使用默认的 ${green}65432${plain} 端口访问面板"
    confirm_restart
}

set_port() {
    echo && echo -n -e "输入端口号[1-65535]: " && read port
    if [[ -z "${port}" ]]; then
        echo -e "${yellow}已取消${plain}"
        before_show_menu
    else
        python3 /usr/local/v2-ui/v2-ui.py setport ${port} &
        sleep 3
        echo -e "设置端口完毕，现在请重启面板，并使用新设置的端口 ${green}${port}${plain} 访问面板"
        confirm_restart
    fi
}

restart() {
    killall python3
    before_show_menu
}

show_menu() {
    echo -e "
  ${green}v2-ui 面板管理脚本${plain}
--- https://blog.sprov.xyz/v2-ui ---
  ${green}0.${plain} 退出脚本
————————————————
  ${green}1.${plain} 重置用户名密码
  ${green}2.${plain} 重置面板设置
  ${green}3.${plain} 设置面板端口
 "
    echo && read -p "请输入选择 [0-3]: " num

    case "${num}" in
        0) exit 0
        ;;
        1) reset_user
        ;;
        2) reset_config
        ;;
        3) set_port
        ;;
        *) echo -e "${red}请输入正确的数字 [0-3]${plain}"
        ;;
    esac
}
show_menu
