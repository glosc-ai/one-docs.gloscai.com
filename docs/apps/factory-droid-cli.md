---
title: Factory Droid CLI
description: Factory Droid CLI 对接 New API 的本地整理指南。
---

# Factory Droid CLI



## 概述

Droid CLI 是 Factory AI 开发的命令行软件工程代理，可在终端中与大型语言模型交互，辅助构建、调试、重构代码和创建应用。通过配置第三方 API，可将请求转到 New API。

## 官方资源

- 官方页面：<https://factory.ai/product/cli>
- 官方文档：<https://docs.factory.ai/cli/getting-started/quickstart>

## 主要能力

| 能力         | 说明                                                  |
| ------------ | ----------------------------------------------------- |
| 快速上手     | 支持在项目目录中启动 `droid` 交互会话。               |
| 特性开发     | 可覆盖从规划、实现到测试的开发流程，并保留人工评审。  |
| 代码库理解   | 利用代码库、文档和 Issue 上下文给出更贴合项目的建议。 |
| 工程系统集成 | 可与 Jira、Notion、Slack 等工具协同。                 |
| 企业能力     | 支持私有部署、合规和受控环境。                        |
| 透明可控     | 提供 diff 查看和审批流程，便于审计代码变更。          |
| 模型灵活性   | 不锁定单一 AI 提供商，可按任务选择合适模型。          |

## AI 模型配置方法

以下命令来自官方页面整理。执行远程脚本前建议先打开脚本链接审阅内容，并确认 New API 地址和令牌来源可信。

### Windows

1. 打开 PowerShell。
2. 安装 Factory Droid CLI：

```powershell
irm https://app.factory.ai/cli/windows | iex
```

3. 修改第三方 API 配置。可直接使用仓库内的一键配置脚本，脚本会默认把 `base_url` 设置为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/factory-cli-setup.ps1')
```

4. 启动 Droid CLI：

```powershell
droid
```

或在项目目录中启动：

```powershell
cd C:\path\to\your\project
droid
```

5. Droid CLI 要求登录官方账号后才能使用。

Windows 常见排障包括安装时权限不足，以及 PowerShell 执行策略限制。执行策略问题可在了解风险后为当前用户设置 `RemoteSigned`。

### macOS / Linux

1. 安装 Droid CLI：

```bash
curl -fsSL https://app.factory.ai/cli | sh
```

2. 根据安装提示将 Droid CLI 加入 PATH。示例：

```bash
echo 'export PATH=/Users/your-name/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

Linux 用户按实际 shell 选择 `~/.bashrc` 或 `~/.zshrc`。

3. 修改第三方 API 配置。可直接使用仓库内的一键配置脚本，脚本会默认把 `base_url` 设置为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/factory-cli-setup.sh | bash
```

4. 启动 Droid CLI：

```bash
droid
```

或在项目目录中启动：

```bash
cd /path/to/your/project
droid
```

5. Droid CLI 要求登录官方账号后才能使用。

## 注意事项

修改第三方 API 配置后，Droid CLI 的模型请求会走你配置的接入点。请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/factory-droid-cli>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19