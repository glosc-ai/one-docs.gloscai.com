---
title: OpenClaw 
description: OpenClaw 对接 New API 的本地整理指南。
---

# OpenClaw - 自托管 AI 智能助手平台



## 概述

OpenClaw 是开源、自托管的个人 AI 助手平台，可把 Telegram、Discord、WhatsApp 等消息应用连接到运行在自己机器或服务器上的 AI 代理。它强调数据控制权、本地上下文和多渠道接入。

## 官方资源

- 官网：<https://openclaw.ai/>
- 文档：<https://docs.openclaw.ai/>
- GitHub：<https://github.com/openclaw/openclaw>

## 核心能力

| 能力       | 说明                                                                  |
| ---------- | --------------------------------------------------------------------- |
| 多渠道集成 | 支持 Telegram、Discord、WhatsApp、iMessage 等渠道，并可通过插件扩展。 |
| 自托管     | 运行在自己的机器或服务器上，代码开源透明，数据和上下文保存在本地。    |
| 智能代理   | 支持后台常驻、持久记忆、计划任务、会话隔离、多代理路由和工具调用。    |

## 接入前准备

需要准备 Node.js 22 或更高版本、可用的 New API 地址和 API Key。请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。

### 安装 OpenClaw

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

其他安装方式可参考 OpenClaw 官方 Getting Started 文档：<https://docs.openclaw.ai/start/getting-started>。

### 运行引导向导

```bash
openclaw onboard --install-daemon
```

该向导会完成基础认证、Gateway 设置，以及可选渠道初始化。

### 检查 Gateway 与 Control UI

```bash
openclaw gateway status
openclaw dashboard
```

如果浏览器能打开 Control UI，说明 OpenClaw 基础运行正常。

### 配置文件位置

OpenClaw 配置文件通常位于 `~/.openclaw/openclaw.json`。如需自定义路径，可关注以下环境变量：

- `OPENCLAW_HOME`
- `OPENCLAW_STATE_DIR`
- `OPENCLAW_CONFIG_PATH`

环境变量说明见官方文档：<https://docs.openclaw.ai/help/environment>。

## 使用 New API 作为模型提供商

OpenClaw 支持通过 `models.providers` 接入自定义或 OpenAI 兼容网关。New API 常见接入方式是声明一个 `newapi` provider，然后把默认模型指向 `newapi/模型ID`。

### 接入思路

1. 在 `models.providers` 下声明 `newapi` provider。
2. 将 `baseUrl` 指向 New API 地址，并包含 `/v1`。
3. 将 `api` 设为 `openai-completions`。
4. 在 `models` 中列出要使用的模型 ID。
5. 在 `agents.defaults.model.primary` 中把默认模型切换到 `newapi/...`。

### 推荐配置片段

先通过环境变量保存密钥：

```bash
export NEWAPI_API_KEY="sk-your-newapi-key"
```

再在 `openclaw.json` 中补充或修改关键配置：

```json
{
  "models": {
    "mode": "merge",
    "providers": {
      "newapi": {
        "baseUrl": "https://<your-newapi-domain>/v1",
        "apiKey": "${NEWAPI_API_KEY}",
        "api": "openai-completions",
        "models": [
          { "id": "gemini-2.5-flash", "name": "Gemini 2.5 Flash" },
          { "id": "kimi-k2.5", "name": "Kimi K2.5" }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "newapi/gemini-2.5-flash",
        "fallbacks": ["newapi/kimi-k2.5"]
      },
      "models": {
        "newapi/gemini-2.5-flash": { "alias": "flash" },
        "newapi/kimi-k2.5": { "alias": "kimi" }
      }
    }
  }
}
```

这不是必须原样照抄的完整配置，关键是 provider、模型 ID 和默认模型引用要对应正确。

### 关键配置说明

| 配置项                            | 说明                                                     |
| --------------------------------- | -------------------------------------------------------- |
| `models.mode`                     | 建议设为 `merge`，保留内置 provider 的同时追加 New API。 |
| `models.providers.newapi.baseUrl` | New API 地址，通常需要带 `/v1`。                         |
| `models.providers.newapi.apiKey`  | New API 密钥，推荐通过环境变量注入。                     |
| `models.providers.newapi.api`     | OpenAI 兼容网关使用 `openai-completions`。               |
| `models.providers.newapi.models`  | 模型 ID 必须与 New API 实际暴露的模型名称一致。          |
| `agents.defaults.model.primary`   | 默认主模型，格式为 `provider/model-id`。                 |
| `agents.defaults.model.fallbacks` | 备选模型列表，主模型失败时自动切换。                     |

### 验证与排障

完成配置后，重新打开 Control UI：

```bash
openclaw dashboard
```

也可以列出模型确认 `newapi/` 前缀的模型已经出现：

```bash
openclaw models list
```

常见问题包括：`baseUrl` 没带 `/v1`、模型 ID 填写错误、后台 Gateway 读不到环境变量。需要前台排障时，可运行 `openclaw gateway --port 18789` 观察日志。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/openclaw>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19