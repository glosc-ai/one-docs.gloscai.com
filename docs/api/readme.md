---
title: API 参考
description: New API 的接口分类、调用基础和文档入口。
---

# API 参考

本文整理自 New API 官方文档的 API 参考页，作为本项目内的快速查阅入口。原始页面：<https://one.gloscai.com/zh/docs/api>。

## 概述

New API 提供 RESTful API 接口，主要分为两类：

| 分类        | 用途                                                                                 | 本地文档                   |
| ----------- | ------------------------------------------------------------------------------------ | -------------------------- |
| AI 模型接口 | 调用聊天、补全、嵌入、图像、音频、视频、重排序等 AI 能力，整体兼容 OpenAI API 风格。 | [AI 模型调用](./ai-model/) |
| 管理接口    | 用于系统配置、用户、渠道、令牌、日志、统计、任务等后台管理能力。                     | 管理接口待整理             |

官方也提供在线调试入口：<https://apifox.newapi.ai/>。

## 基础调用约定

大多数 AI 模型接口采用以下调用方式：

| 项       | 值                                                                                             |
| -------- | ---------------------------------------------------------------------------------------------- |
| Base URL | `https://one.gloscai.com/v1`，私有化部署时替换为自己的服务地址。                               |
| 认证     | `Authorization: Bearer TOKEN`                                                                  |
| 请求体   | JSON 接口通常使用 `Content-Type: application/json`；视频等接口可能使用 `multipart/form-data`。 |
| 兼容性   | OpenAI 格式为主；部分接口会根据请求头或路径兼容 Anthropic、Gemini、Sora、Kling、即梦等格式。   |

```bash
curl -X GET "https://one.gloscai.com/v1/models" \
  -H "Authorization: Bearer sk-xxxxxx"
```

## AI 模型接口目录

| 能力                                       | 方法与路径                        | 说明                                         |
| ------------------------------------------ | --------------------------------- | -------------------------------------------- |
| [模型列表](./ai-model/models/list.md)      | `GET /v1/models`                  | 获取当前可用模型列表。                       |
| [聊天](./ai-model/chat/completions.md)     | `POST /v1/chat/completions`       | 根据对话历史创建模型响应，支持流式和非流式。 |
| [补全](./ai-model/completions/create.md)   | `POST /v1/completions`            | 传统文本补全接口。                           |
| [嵌入](./ai-model/embeddings/create.md)    | `POST /v1/embeddings`             | 将文本转换为向量嵌入。                       |
| [重排序](./ai-model/rerank/create.md)      | `POST /v1/rerank`                 | 根据查询对文档列表做相关性重排序。           |
| [审查](./ai-model/moderations/create.md)   | `POST /v1/moderations`            | 对输入内容做安全审核。                       |
| [音频](./ai-model/audio/speech.md)         | `POST /v1/audio/speech` 等        | 文本转语音、音频转录、音频翻译等。           |
| [图像](./ai-model/images/generations.md)   | `POST /v1/images/generations/` 等 | 图像生成、图像编辑等。                       |
| [实时语音](./ai-model/realtime/session.md) | `GET /v1/realtime`                | WebSocket 实时对话端点。                     |
| [视频](./ai-model/videos/sora-create.md)   | `POST /v1/videos` 等              | 视频生成任务、任务状态、视频内容获取。       |

详细参数和示例见 [AI 模型调用](./ai-model/)。

## 管理接口目录

管理接口用于后台配置和业务管理，包括系统状态、系统设置、用户认证、用户管理、双因素认证、OAuth、渠道管理、模型管理、令牌管理、兑换码、支付、日志、统计、任务、分组、供应商和安全验证等。

管理接口分类后续可按相同方式拆分为独立目录。

## 来源与维护

- 来源页面：<https://one.gloscai.com/zh/docs/api>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19
