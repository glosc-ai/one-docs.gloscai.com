---
title: GitHub Copilot CLI
description: GitHub Copilot CLI 通过 BYOK 模式接入自定义模型的本地整理指南。
---

# GitHub Copilot CLI

## 概述

GitHub Copilot CLI 可通过 BYOK 模式接入 OpenAI Chat Completions 兼容端点。`https://one.gloscai.com/v1` 应按官方文档中的 `openai` provider type 配置。

## 官方资源

- Copilot CLI 入门：<https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-getting-started>
- BYOK 文档：<https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models>

## 安装

需要 Node.js 22 或更高版本：

```bash
npm install -g @github/copilot
```

## 一键配置

脚本会设置 `COPILOT_PROVIDER_TYPE=openai`，默认把 `COPILOT_PROVIDER_BASE_URL` 写为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/copilot-cli-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/copilot-cli-setup.sh | bash
```

## 使用

```bash
copilot
```

如需临时切换模型，也可以在启动时使用 `--model` 参数覆盖 `COPILOT_MODEL`。

## 注意事项

模型必须支持流式输出和工具调用，否则 Copilot CLI 会在执行 Agent 任务时返回能力不满足的错误。