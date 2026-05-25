---
title: nanobot
description: nanobot 通过 config.json 接入自定义模型的本地整理指南。
---

# nanobot

## 概述

nanobot 是轻量级 AI 智能体，支持通过 `~/.nanobot/config.json` 配置 provider、默认模型和 API Key。

## 官方资源

- uv：<https://github.com/astral-sh/uv>
- nanobot：<https://pypi.org/project/nanobot-ai/>

## 安装

```bash
uv tool install nanobot-ai
nanobot --version
```

Windows 如需更新 PATH，可执行：

```powershell
$env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"
```

## 一键配置

脚本会生成 `~/.nanobot/config.json`，默认 `apiBase` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/nanobot-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/nanobot-setup.sh | bash
```

## 使用

```bash
nanobot agent
```