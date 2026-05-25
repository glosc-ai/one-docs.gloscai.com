---
title: Langcli
description: Langcli CLI 与 Zed ACP Agent 的本地整理指南。
---

# Langcli

## 概述

Langcli 是支持 CLI 和 Zed ACP Agent 的 AI 编程助手。公开快速开始主要依赖 LangRouter 账号和 API Key。

## 官方资源

- 官网：<https://langcli.com/>
- LangRouter：<https://langrouter.ai/>

## 安装

macOS、Linux 和 WSL：

```bash
bash -c "$(curl -fsSL https://assets.langcli.com/installation/install-langcli.sh)"
```

Windows 需以管理员身份运行 PowerShell：

```powershell
cmd /c "curl -fsSL -o %TEMP%\install-langcli.bat https://assets.langcli.com/installation/install-langcli.bat && %TEMP%\install-langcli.bat"
```

也可以手动安装：

```bash
npm i -g langcli-com
```

## 使用

在 LangRouter 获取 API Key 后运行：

```bash
langcli
```

进入会话后输入 `hi` 开始对话。

## 注意事项

Langcli 的公开文档使用 LangRouter 自身的账号和 Key 流程，当前未确认稳定的本地 OpenAI 兼容配置文件格式，因此不提供面向 `one.gloscai.com` 的一键配置脚本。