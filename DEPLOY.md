# 一键部署指南

## 前置要求

- Node.js >= 18.x
- npm >= 9.x
- Git

## 快速部署

### 1. 克隆项目

```bash
git clone https://github.com/wcc0077/claudecodeui.git
cd claudecodeui
```

### 2. 安装依赖

```bash
npm install
```

### 3. 配置环境变量（可选）

```bash
cp .env.example .env
```

编辑 `.env` 文件，配置必要的 API 密钥：

```env
# 端口配置
PORT=3001

# 数据库路径
DATABASE_PATH=~/.claude-code-ui/auth.db

# API 密钥（按需配置）
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
GEMINI_API_KEY=
```

### 4. 启动服务

**开发模式（推荐）：**

```bash
npm run dev
```

同时启动前端（端口 5173）和后端（端口 3001）

**生产模式：**

```bash
# 构建
npm run build

# 启动
npm run server
```

## 验证部署

访问 http://localhost:5173 查看前端界面

## 常用命令

```bash
npm run dev        # 开发模式
npm run build      # 生产构建
npm run server     # 仅启动后端
npm run client     # 仅启动前端
npm run lint       # 代码检查
npm run typecheck  # 类型检查
```

## 故障排查

### 端口被占用

修改 `.env` 中的 `PORT` 值

### 依赖安装失败

```bash
rm -rf node_modules package-lock.json
npm install
```

### 数据库错误

```bash
rm -rf ~/.claude-code-ui/auth.db
# 重启服务会自动创建新数据库
```
