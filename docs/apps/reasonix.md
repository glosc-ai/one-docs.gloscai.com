---
title: Reasonix
description: Reasonix 终端编程 Agent 的本地整理指南。
---

# Reasonix

## 概述

Reasonix 是终端编程 Agent，设计围绕缓存优先循环、低成本日常模型和工具调用自动修复展开。

## 官方资源

- GitHub：<https://github.com/esengine/reasonix>

## 使用前准备

1. 安装 Node.js 20.10 或更高版本。
2. Windows 用户安装 Git for Windows。
3. 准备 API Key。Reasonix 首次启动会通过内置向导询问 Key，并持久化到 `~/.reasonix/config.json`。

## 启动

无需全局安装：

```bash
cd /path/to/my-project
npx reasonix code
```

Reasonix 默认使用轻量模型做日常迭代。TUI 中输入 `/pro` 可在下一轮切换到更强模型，输入 `/preset max` 可让整个 session 使用高强度配置。

## 注意事项

当前未确认 Reasonix 是否提供稳定的自定义 OpenAI 兼容 Base URL 配置格式，因此本仓库不提供一键写文件脚本。若你的版本在首次启动向导中支持自定义接口，请填写 `https://one.gloscai.com/v1`、你的 `AUTH_TOKEN` 和模型名称。