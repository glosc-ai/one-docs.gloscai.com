---
title: OpenCode
description: OpenCode 接入自定义 OpenAI 兼容接口的本地整理指南。
---

# OpenCode

## 概述

OpenCode 是开源 AI 编程助手，提供终端和网页等运行形态。OpenCode 支持通过配置文件声明任意 OpenAI 兼容自定义 provider。

## 官方资源

- 官网：<https://opencode.ai/>
- 下载：<https://opencode.ai/zh/download>
- Provider 文档：<https://opencode.ai/docs/providers/>
- 配置文档：<https://opencode.ai/docs/config/>

## 一键配置

脚本会生成 `~/.config/opencode/opencode.json`，默认 `baseURL` 为 `https://one.gloscai.com/v1`，并交互式要求输入 `AUTH_TOKEN` 和 `DEFAULT_MODEL`。Token 会写入 `ONE_API_KEY` 环境变量，配置文件通过 `{env:ONE_API_KEY}` 引用。

Windows：

```powershell
iex (irm 'https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/opencode-setup.ps1')
```

macOS / Linux：

```bash
curl -fsSL https://raw.githubusercontent.com/glosc-ai/one-docs.gloscai.com/main/scripts/opencode-setup.sh | bash
```

## 手动配置

如已安装，先升级：

```bash
opencode upgrade
```

启动 OpenCode：

```bash
opencode
```

如果不使用脚本，可以在 OpenCode 中执行 `/connect`，选择 `Other`，输入 provider id（例如 `one`）和 API Key，然后在 `opencode.json` 中添加 `@ai-sdk/openai-compatible` provider、`options.baseURL` 和模型列表。

## 注意事项

模型需要支持工具调用。若模型走 `/v1/responses` 而不是 `/v1/chat/completions`，请按 OpenCode 文档把 provider 的 `npm` 改为 `@ai-sdk/openai`。