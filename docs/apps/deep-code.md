---
title: Deep Code
description: Deep Code CLI 接入自定义模型的本地整理指南。
---

# Deep Code

## 概述

Deep Code 是开源终端 AI 编程助手，支持深度思考、推理强度控制以及 Agent Skills。配置文件与 Deep Code VS Code 扩展共享。

## 官方资源

- GitHub：<https://github.com/lessweb/deepcode-cli>

## 安装

```bash
npm install -g @vegamo/deepcode-cli
deepcode --version
```

## 一键配置

脚本会生成 `~/.deepcode/settings.json`，默认 `BASE_URL` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/deepcode-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/deepcode-setup.sh | bash
```

## 使用

```bash
cd /path/to/my-project
deepcode
```

Agent Skills 可放在用户级 `~/.agents/skills/<name>/SKILL.md` 或项目级 `./.deepcode/skills/<name>/SKILL.md`。