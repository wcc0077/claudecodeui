#!/bin/bash

# ClaudeCodeUI PM2 一键部署脚本
# 适用于 Linux/macOS 环境

set -e

echo "========================================"
echo "  ClaudeCodeUI PM2 一键部署脚本"
echo "========================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 Node.js
check_node() {
    if ! command -v node &> /dev/null; then
        log_error "Node.js 未安装，请先安装 Node.js >= 18.x"
        exit 1
    fi

    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        log_error "Node.js 版本过低 ($NODE_VERSION)，需要 >= 18.x"
        exit 1
    fi

    log_info "Node.js 版本检查通过：$(node -v)"
}

# 检查 PM2
check_pm2() {
    if ! command -v pm2 &> /dev/null; then
        log_warn "PM2 未安装，正在安装..."
        npm install -g pm2
    else
        log_info "PM2 已安装：$(pm2 -v)"
    fi
}

# 安装依赖
install_deps() {
    log_info "安装项目依赖..."
    npm install --production
}

# 构建项目
build_project() {
    log_info "构建项目..."
    npm run build
}

# 创建日志目录
create_logs_dir() {
    log_info "创建日志目录..."
    mkdir -p logs
}

# 停止旧应用
stop_app() {
    log_info "停止旧应用（如有）..."
    pm2 stop claudecodeui 2>/dev/null || true
    pm2 delete claudecodeui 2>/dev/null || true
}

# 启动应用
start_app() {
    log_info "启动应用..."
    pm2 start ecosystem.config.js
}

# 保存 PM2 配置
save_pm2_config() {
    log_info "保存 PM2 配置（开机自启）..."
    pm2 save
}

# 显示状态
show_status() {
    echo ""
    log_info "应用状态："
    pm2 status claudecodeui
    echo ""
    log_info "应用已启动！"
    log_info "访问地址：http://localhost:5173"
    echo ""
    log_info "常用命令："
    echo "  pm2 logs claudecodeui     # 查看日志"
    echo "  pm2 restart claudecodeui  # 重启应用"
    echo "  pm2 stop claudecodeui     # 停止应用"
    echo "  pm2 monit                 # 监控状态"
}

# 主流程
main() {
    check_node
    check_pm2
    install_deps
    build_project
    create_logs_dir
    stop_app
    start_app
    save_pm2_config
    show_status
}

# 执行
main
