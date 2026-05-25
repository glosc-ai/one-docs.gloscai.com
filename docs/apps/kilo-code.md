---
title: Kilo Code
description: Kilo Code CLI 接入自定义模型的本地整理指南。
---

# Kilo Code

## 概述

Kilo Code 是支持 CLI 和编辑器扩展的 AI 编程助手。公开文档主要推荐通过 Kilo Gateway 或应用内 provider 连接流程配置模型。

## 官方资源

- Kilo Code：<https://kilo.ai/docs>
- Kilo Gateway：<https://kilo.ai/docs/gateway>

## 安装

```bash
npm install -g @kilocode/cli
kilo --version
```

## 配置方法

进入项目目录并启动：

```bash
cd /path/to/my-project
kilo
```

在命令栏输入 `/connect`，优先选择 `OpenAI Compatible`、`Custom API Provider` 或类似自定义接口入口，然后填入：

- Base URL：`https://one.gloscai.com/v1`
- API Key：你的 `AUTH_TOKEN`
- Model：你的 `DEFAULT_MODEL`

随后输入 `/models` 打开模型选择器，选择刚添加的模型。

## 注意事项

Kilo Code 当前公开文档未提供稳定的用户级配置文件格式，因此本仓库不提供一键写文件脚本。如果你的版本没有自定义 OpenAI 兼容入口，可改用 Kilo Gateway 或选择本页列表中已脚本化的终端 Agent。