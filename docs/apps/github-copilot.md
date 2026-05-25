---
title: GitHub Copilot
description: GitHub Copilot 与自定义 OpenAI 兼容接口的支持情况说明。
---

# GitHub Copilot

## 概述

GitHub Copilot Chat 是 GitHub 托管的 VS Code 编程助手。当前公开文档没有提供在 VS Code Copilot Chat 里直接填写任意 OpenAI 兼容 Base URL 和 API Key 的稳定入口。

## 官方资源

- VS Code：<https://code.visualstudio.com/>
- GitHub Copilot 文档：<https://docs.github.com/copilot>
- Copilot CLI BYOK：<https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-byok-models>

## 配置方法

如需在终端 Agent 中使用 `https://one.gloscai.com/v1`，请使用 [GitHub Copilot CLI](./github-copilot-cli.md) 的 BYOK 模式。

如果你只使用 VS Code 内置 Copilot Chat，则继续使用 GitHub 官方模型选择器；不要把面向某个单独服务商的第三方插件当作 `one.gloscai.com` 的通用配置方式。

## 可选配置

目前没有仓库脚本直接写 VS Code Copilot Chat 自定义 provider 配置。

## 注意事项

本页只说明支持边界。需要可脚本化的自定义接口接入时，优先选择 Copilot CLI、OpenCode、Crush、Pi 或 Hermes 这类公开配置格式的终端 Agent。