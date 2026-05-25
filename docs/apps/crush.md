---
title: Crush
description: Crush 通过 crush.json 接入自定义 provider 的本地整理指南。
---

# Crush

## 概述

Crush 是 Charm 开发的开源终端 AI 编程 Agent，支持多模型切换、LSP 集成、MCP 服务器和代理式编码工作流。

## 官方资源

- Charm：<https://charm.land/>
- GitHub：<https://github.com/charmbracelet/crush>

## 安装

```bash
npm install -g @charmland/crush
crush --version
```

macOS 也可以使用 Homebrew：

```bash
brew install charmbracelet/tap/crush
```

## 一键配置

脚本会生成 `~/.config/crush/crush.json`，默认 `base_url` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。脚本会把 Token 写入 `ONE_API_KEY` 环境变量，并在 provider 中使用 `openai-compat` 类型。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/crush-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/crush-setup.sh | bash
```

## 使用

```bash
cd /path/to/my-project
crush
```

按 `Ctrl+L` 或输入 `/model` 打开模型切换器，选择脚本生成的 provider 和模型。