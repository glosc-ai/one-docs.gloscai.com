---
title: WorkBuddy/CodeBuddy
description: WorkBuddy/CodeBuddy 通过本地 models.json 接入自定义模型的本地整理指南。
---

# WorkBuddy/CodeBuddy

## 概述

WorkBuddy/CodeBuddy 支持通过本地 `models.json` 添加 OpenAI 兼容模型。本文使用用户级 `.codebuddy/models.json` 和 `ONE_API_KEY` 环境变量接入 `https://one.gloscai.com/v1`。

## 官方资源

- CodeBuddy 文档：<https://www.codebuddy.ai/docs>

## 一键配置

脚本会默认使用 `https://one.gloscai.com/v1/chat/completions`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。脚本会把 Token 写入 `ONE_API_KEY` 用户环境变量，并生成用户级 `.codebuddy/models.json`。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/workbuddy-codebuddy-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/workbuddy-codebuddy-setup.sh | bash
```

## 使用

完全退出 WorkBuddy/CodeBuddy 后重新打开，在模型选择器中选择脚本生成的模型。

## 排障

- `Authentication Fails` 或 `401`：确认 `ONE_API_KEY` 是真实 API Key。
- 模型不显示：确认 `.codebuddy/models.json` 是合法 JSON，并完全重启应用。
- UI 直接显示 `${ONE_API_KEY}`：从已加载环境变量的新终端启动应用，或在 UI 中填入真实 Key。