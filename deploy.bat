@echo off
REM ClaudeCodeUI PM2 一键部署脚本 (Windows)
REM 适用于 Windows 环境

echo ========================================
echo   ClaudeCodeUI PM2 一键部署脚本
echo ========================================

REM 检查 Node.js
echo [INFO] 检查 Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js 未安装，请先安装 Node.js >= 18.x
    pause
    exit /b 1
)
echo [INFO] Node.js 版本：
node -v

REM 检查 PM2
echo [INFO] 检查 PM2...
pm2 -v >nul 2>&1
if errorlevel 1 (
    echo [WARN] PM2 未安装，正在安装...
    call npm install -g pm2
) else (
    echo [INFO] PM2 已安装
    pm2 -v
)

REM 安装依赖
echo [INFO] 安装项目依赖...
call npm install --production

REM 构建项目
echo [INFO] 构建项目...
call npm run build

REM 创建日志目录
echo [INFO] 创建日志目录...
if not exist logs mkdir logs

REM 停止旧应用
echo [INFO] 停止旧应用...
pm2 stop claudecodeui 2>nul || goto :ignore1
pm2 delete claudecodeui 2>nul || goto :ignore2

:ignore1
:ignore2

REM 启动应用
echo [INFO] 启动应用...
pm2 start ecosystem.config.js

REM 保存 PM2 配置
echo [INFO] 保存 PM2 配置...
pm2 save

echo.
echo [INFO] 应用已启动！
echo [INFO] 访问地址：http://localhost:5173
echo.
echo [INFO] 常用命令：
echo   pm2 logs claudecodeui     # 查看日志
echo   pm2 restart claudecodeui  # 重启应用
echo   pm2 stop claudecodeui     # 停止应用
echo   pm2 monit                 # 监控状态
echo.
pause
