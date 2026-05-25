---
title: OpenAI Codex CLI
description: OpenAI Codex CLI 对接 New API 的本地整理指南。
---

# OpenAI Codex CLI



## 概述

Codex CLI 是 OpenAI 的终端编码代理，可在本地计算机运行，用于编辑代码、生成补丁、运行命令和协助完成软件开发任务。通过配置 Codex CLI 的接入点，可以让模型请求走 New API。

## 官方资源

- 官方页面：<https://chatgpt.com/codex>
- GitHub：<https://github.com/openai/codex>
- Windows 指南：<https://developers.openai.com/codex/windows>

## 主要能力

| 能力           | 说明                                                   |
| -------------- | ------------------------------------------------------ |
| 终端式编码助手 | 在命令行中交互式编辑代码、生成补丁并运行命令。         |
| 工具驱动       | 使用文件补丁、shell、计划追踪等工具完成任务。          |
| 原子补丁       | 通过专用补丁格式添加、更新、删除文件，便于审计和回滚。 |
| 沙箱与审批     | 支持沙箱策略和审批模式，控制写入与网络访问。           |
| 测试与格式化   | 修改后可运行相关测试和格式化工具。                     |
| 并行执行       | 可通过并行工具调用提升多文件读取和检查效率。           |

## AI 模型配置方法

以下命令来自官方页面整理。执行远程脚本前建议先打开脚本链接审阅内容，并确认 New API 地址和令牌来源可信。

### Windows

1. 打开 PowerShell。
2. 安装 WSL2，安装完成后重启 Windows：

```powershell
wsl --install
```

3. 在 WSL 中安装 NVM：

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

4. 新开 PowerShell 并进入 WSL，安装 Node.js 22。版本要求可能会随 OpenAI 官方文档更新：

```bash
wsl
nvm install 22
```

5. 安装 Codex CLI：

```bash
npm i -g @openai/codex
```

6. 修改配置文件。可直接使用仓库内的一键配置脚本，脚本会默认把 Codex 的 `base_url` 设置为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/codex-cli-setup.ps1')
```

7. 启动 WSL 后运行 Codex：

```bash
wsl
codex
```

或在项目目录中启动：

```bash
cd /mnt/c/path/to/your/project
codex
```

8. 可在 Codex CLI 中输入 `/model` 选择模型，并按需要设置文件修改权限。

### macOS

1. 如未安装 Homebrew，可参考 <https://brew.sh/> 安装。
2. 安装 Node.js：

```bash
brew update
brew install node
```

3. 验证 Node.js 和 npm：

```bash
node --version
npm --version
```

4. 安装 Codex CLI：

```bash
npm install -g @openai/codex
```

如遇权限问题，可使用 `sudo npm install -g @openai/codex`，或配置 npm 使用用户目录。

5. 验证安装：

```bash
codex --version
```

6. 修改配置文件。可直接使用仓库内的一键配置脚本，脚本会默认把 Codex 的 `base_url` 设置为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/codex-cli-setup.sh | bash
```

7. 启动使用：

```bash
codex
```

或在项目目录中启动：

```bash
cd /path/to/your/project
codex
```

### Linux

1. 安装 Node.js。官方页面示例使用 NodeSource：

```bash
sudo curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. 验证安装：

```bash
node --version
npm --version
```

3. 安装 Codex CLI：

```bash
npm install -g @openai/codex
```

如遇权限问题，可使用 `sudo npm install -g @openai/codex`，或配置 npm 使用用户目录。

4. 验证安装：

```bash
codex --version
```

5. 修改配置文件：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/codex-cli-setup.sh | bash
```

6. 启动使用：

```bash
codex
```

或在项目目录中启动：

```bash
cd /path/to/your/project
codex
```

Linux 常见排障包括 npm 全局安装权限不足、缺少构建工具、PATH 未更新等。

## 注意事项

修改接口地址后，Codex CLI 的模型请求会走你配置的自有或组织授权接入点。请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/codex-cli>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19