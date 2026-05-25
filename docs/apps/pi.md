---
title: Pi
description: Pi coding agent 通过 models.json 接入自定义 provider 的本地整理指南。
---

# Pi

## 概述

Pi 是极简且可扩展的终端编码框架，支持树状会话、技能、提示模板和主题。Pi 可通过 `models.json` 添加 OpenAI 兼容 provider。

## 官方资源

- Pi 安装脚本：<https://pi.dev/install.sh>
- 模型文档：<https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/docs/models.md>

## 安装

```bash
npm install -g @mariozechner/pi-coding-agent
pi --version
```

Linux / macOS 也可以使用官方脚本：

```bash
curl -fsSL https://pi.dev/install.sh | sh
```

## 一键配置

脚本会生成 `~/.pi/agent/models.json`，默认 `baseUrl` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。脚本会把 Token 写入 `ONE_API_KEY` 环境变量。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/pi-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/pi-setup.sh | bash
```

## 使用

```bash
cd /path/to/my-project
pi
```

输入 `/model` 打开模型切换器，选择脚本生成的 provider 和模型。

## 注意事项

脚本采用通用 OpenAI Chat Completions 兼容配置，并关闭 provider 专属 thinking 参数。如果你的上游模型需要特殊 reasoning 字段，可按 Pi 的模型文档在 `compat` 中手动补充。