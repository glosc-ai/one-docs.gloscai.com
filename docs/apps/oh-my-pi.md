---
title: Oh My Pi
description: Oh My Pi 通过 models.yml 接入自定义模型的本地整理指南。
---

# Oh My Pi

## 概述

Oh My Pi 是终端 AI 编程 Agent，支持在 `~/.omp/agent/models.yml` 中声明自定义 OpenAI 兼容 provider。

## 官方资源

- GitHub：<https://github.com/can1357/oh-my-pi>
- Provider 说明：<https://omp.sh/docs/providers>

## 一键配置

脚本会生成 `~/.omp/agent/models.yml`，默认 `baseUrl` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。脚本会把 Token 写入 `ONE_API_KEY` 环境变量。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/oh-my-pi-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/oh-my-pi-setup.sh | bash
```

## 使用

```bash
cd /path/to/your-project
omp --model one/<DEFAULT_MODEL>
```

也可以在 Oh My Pi 内输入 `/model` 或按 `Ctrl+L` 切换模型。

## 注意事项

脚本采用通用 OpenAI Chat Completions 兼容配置，并关闭 provider 专属 thinking 参数。如果你的模型需要特殊 reasoning 开关，可在 `models.yml` 的 `compat` 或 `thinking` 区块中手动补充。