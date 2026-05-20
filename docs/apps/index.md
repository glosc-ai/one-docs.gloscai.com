---
title: AI 应用
description: New API 已验证支持的 AI 应用和集成入口。
---

# AI 应用

本文整理自 New API 官方 AI 应用文档，作为本项目内的本地查阅入口。原始页面：<https://www.newapi.ai/zh/docs/apps>。

## 概述

New API 可以作为 OpenAI 兼容网关接入多种 AI 客户端、机器人平台、翻译工具和终端编程助手。多数应用只需要填写服务地址、API Key 和模型名称；部分应用还支持从 New API 控制台通过 Deep Link 一键导入配置。

## 支持的应用

| 应用                | 本地页面                                    | 主要用途                                                           |
| ------------------- | ------------------------------------------- | ------------------------------------------------------------------ |
| Gloss Mod Manager   | [Gloss Mod Manager](./glossmodmanager.md)   | 你的下一代 智能游戏模组 管理器                                     |
| AionUi              | [AionUi](./aionui.md)                       | 免费开源桌面办公 Agent，支持多代理、多模型、文件管理和预览。       |
| CC Switch           | [CC Switch](./cc-switch.md)                 | Claude Code、Codex、Gemini CLI 的 Provider、MCP 和提示词统一管理。 |
| Cherry Studio       | [Cherry Studio](./cherry-studio.md)         | 桌面 AI 客户端，支持多模型对话和图像能力。                         |
| DeepChat            | [DeepChat](./deepchat.md)                   | 全功能 AI Agent 客户端，支持 Deep Link 导入 Provider。             |
| Memoh               | [Memoh](./memoh.md)                         | 容器化 AI 智能体平台，支持长期记忆、多渠道和 MCP。                 |
| 流畅阅读 FluentRead | [流畅阅读](./fluent-read.md)                | 开源浏览器翻译插件，支持传统翻译和 AI 大模型翻译。                 |
| OpenClaw            | [OpenClaw](./openclaw.md)                   | 自托管个人 AI 助手平台，支持多消息渠道和自定义模型 provider。      |
| LangBot             | [LangBot](./langbot.md)                     | 即时通信机器人开发平台，支持知识库、Agent、MCP 和多平台机器人。    |
| AstrBot             | [AstrBot](./astrbot.md)                     | 一站式 Agent 聊天机器人平台，可接入 QQ、飞书、钉钉、企业微信等。   |
| LunaTranslator      | [LunaTranslator](./luna-translator.md)      | 开源 GalGame / 视觉小说翻译器，支持 HOOK、OCR 和大模型翻译。       |
| Claude Code         | [Claude Code](./claude-code.md)             | Anthropic 终端编程助手，可通过环境变量对接 New API。               |
| OpenAI Codex CLI    | [OpenAI Codex CLI](./codex-cli.md)          | 终端 AI 编程助手，可配置自有 OpenAI 兼容接入点。                   |
| Factory Droid CLI   | [Factory Droid CLI](./factory-droid-cli.md) | Factory AI 的命令行软件工程助手，可配置第三方 API。                |

## 通用接入信息

| 配置项   | 说明                                                                                                            |
| -------- | --------------------------------------------------------------------------------------------------------------- |
| API 地址 | New API 服务地址。多数 OpenAI 兼容客户端需要填写到 `/v1`，个别应用会要求不带 `/v1`。                            |
| API Key  | 在 New API 控制台的令牌管理中创建并复制。                                                                       |
| 模型名称 | 与 New API 中实际暴露的模型名称保持一致。                                                                       |
| 合规要求 | 请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。 |

## 集成建议

1. 先在 New API 中确认令牌额度、可用模型和分组权限。
2. 按应用要求填写 API 地址，注意是否需要 `/v1`。
3. 在应用内刷新或手动添加模型列表，确保模型名与 New API 一致。
4. 完成配置后先用简单对话或测试请求验证，再接入正式工作流。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19