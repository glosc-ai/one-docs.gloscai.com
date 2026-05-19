---
title: Claude Code
description: Claude Code 对接 New API 的本地整理指南。
---

# Claude Code



## 概述

Claude Code 是 Anthropic 的终端编程助手，支持代码库理解、多文件编辑、测试与自动化流程，并可集成 VS Code 和 JetBrains IDE。通过配置环境变量，可以把 Claude Code 请求转到 New API 兼容接入点。

## 官方资源

- Claude Code 官方页面：<https://www.anthropic.com/claude-code>

## 主要能力

| 能力         | 说明                                                     |
| ------------ | -------------------------------------------------------- |
| 代码理解     | 深度分析代码库，帮助理解项目结构和依赖。                 |
| 代码编辑     | 支持多文件协同编辑，适合复杂修改和重构。                 |
| 集成能力     | 可在终端中运行，并集成 VS Code、JetBrains IDE。          |
| 生成与优化   | 可生成代码、创建测试、修复错误，覆盖从需求到提交的流程。 |
| 安全与灵活性 | 文件和命令操作需要用户授权，可适配项目代码规范。         |
| 工具链整合   | 可结合 GitHub、GitLab、测试套件和构建系统。              |

## AI 模型配置方法

以下命令来自官方页面整理。执行远程脚本前建议先打开脚本链接审阅内容，并确认 New API 地址和令牌来源可信。

### Windows

1. 安装 Node.js LTS：<https://nodejs.org/>。
2. 安装 Git for Windows：<https://git-scm.com/downloads/win>。Windows 下官方页面建议使用 Git Bash 安装 Claude Code，但环境变量配置和日常使用仍可在 PowerShell 或 CMD 中进行。
3. 在 PowerShell 中安装 Claude Code：

```powershell
npm install -g @anthropic-ai/claude-code
```

如安装提示需要把 `~/.local/bin` 加入 PATH，可按提示添加用户 PATH。

4. 验证安装：

```powershell
claude --version
```

5. 配置 New API 环境变量。官方页面提供一键配置脚本：

```powershell
iex (irm 'https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.ps1')
```

6. 启动使用：

```powershell
claude
```

或在项目目录中启动：

```powershell
cd C:\path\to\your\project
claude
```

7. 可在 Claude Code 中输入 `/model` 选择模型。

### macOS

1. 安装 Claude Code CLI：

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

如安装提示需要添加 PATH，可按提示写入 shell 配置文件。

2. 配置 New API 环境变量。官方页面提供一键配置脚本：

```bash
curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.sh | bash
```

3. 验证安装：

```bash
claude --version
```

4. 启动使用：

```bash
claude
```

或在项目目录中启动：

```bash
cd /path/to/your/project
claude
```

5. 可输入 `/model` 选择模型。

macOS 若系统阻止运行，可在系统设置的安全性与隐私中允许，或按官方指引处理安全策略。

### Linux

1. 安装 Claude Code：

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

如遇权限问题，可按系统策略使用管理员权限。

2. 验证安装：

```bash
claude --version
```

3. 配置 New API 环境变量：

```bash
curl -fsSL https://raw.githubusercontent.com/QuantumNous/new-api-docs/refs/heads/main/helper/claude-cli-setup.sh | bash
```

4. 启动使用：

```bash
claude
```

或在项目目录中启动：

```bash
cd /path/to/your/project
claude
```

5. 可输入 `/model` 选择模型。

常见 Linux 排障包括安装缺少构建依赖、环境变量未生效、shell 配置文件未重新加载等。

## 注意事项

配置 `ANTHROPIC_BASE_URL` 等环境变量后，Claude Code 的模型请求会走自定义接入点。请确保接入点是自己部署或组织授权的 New API 服务，并避免把不可信地址和密钥用于生产环境。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/claude-code>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19