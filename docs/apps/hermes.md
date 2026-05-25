---
title: Hermes
description: Hermes Agent 接入自定义 OpenAI 兼容接口的本地整理指南。
---

# Hermes

## 概述

Hermes 是 Nous Research 打造的开源自我进化 AI Agent，能够从经验中生成技能、沉淀知识，并跨会话学习用户偏好。Hermes 支持把主模型配置为 `provider: custom`，直接连接 OpenAI 兼容端点。

## 官方资源

- 官网文档：<https://hermes-agent.nousresearch.com/docs/getting-started/installation>
- 安装脚本：<https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh>
- Provider 文档：<https://hermes-agent.nousresearch.com/docs/integrations/providers>
- 配置文档：<https://hermes-agent.nousresearch.com/docs/user-guide/configuration>

## 安装

Linux / macOS / WSL2：

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

## 一键配置

脚本会更新 `~/.hermes/config.yaml` 的顶层 `model:` 区块，默认 `base_url` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。Token 会写入 `~/.hermes/.env` 与 `ONE_API_KEY` 用户环境变量。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/hermes-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/hermes-setup.sh | bash
```

## 手动配置

重新加载 shell 后运行：

```bash
hermes setup
```

选择 `Custom endpoint`，输入 API Base URL、API Key 和模型名称。也可以直接编辑 `~/.hermes/config.yaml`：

```yaml
model:
  provider: custom
  default: your-model-name
  base_url: https://one.gloscai.com/v1
  api_key: ${ONE_API_KEY}
  api_mode: chat_completions
```

## 注意事项

Hermes 要求 Agent 模型具备足够上下文窗口和可靠工具调用能力。脚本默认写入 `context_length: 128000`，如你的模型窗口更大或更小，可在 `config.yaml` 中调整。