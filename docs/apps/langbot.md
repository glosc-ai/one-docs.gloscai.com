---
title: LangBot 
description: LangBot 对接 New API 的本地整理指南。
---

# LangBot - 即时通信机器人开发平台



## 概述

LangBot 是开源即时通信机器人开发平台，支持飞书、钉钉、微信、QQ、Telegram、Discord、Slack 等平台。它支持知识库、Agent、MCP 等 AI 应用能力，并可通过 New API 接入模型和嵌入服务。

## 官方资源

- 官网：<https://langbot.app/>
- 下载：<https://github.com/langbot-app/LangBot/releases>
- 文档：<https://docs.langbot.app/>
- GitHub：<https://github.com/langbot-app/LangBot>

## 接入 New API

LangBot 支持本地部署的 New API，也支持第三方使用 New API 搭建的服务。若是本地部署，请结合容器网络情况确认服务地址；若使用第三方服务，请从页面复制地址并确认来源可信。多数模型配置需要在地址末尾添加 `/v1`。

容器网络说明可参考 LangBot 文档：<https://docs.langbot.app/zh/workshop/network-details.html>。

### 使用模型服务

1. 在 New API 中创建并复制 API Key。
2. 在 LangBot 中添加模型。
3. 选择 New API 供应商，填写 API Key 和 API 地址。
4. 在流水线中选择刚添加的模型。
5. 在对话调试中测试，或与绑定至流水线的机器人对话。

部署具体机器人可参考官方文档：<https://docs.langbot.app/zh/deploy/platforms/readme.html>。

### 使用 LangBot 知识库

LangBot 可以使用 New API 的嵌入模型作为知识库向量模型。

1. 在 LangBot 中添加嵌入模型。
2. 选择 New API 供应商并填写对应配置。
3. 新建知识库时选用该嵌入模型。
4. 导入知识库内容后，在流水线或机器人中使用知识库能力。

更多用法见 LangBot 官方文档：<https://docs.langbot.app/>。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/langbot>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19