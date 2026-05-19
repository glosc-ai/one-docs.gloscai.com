---
title: 聊天补全
description: 根据对话历史创建模型响应。
---

# 聊天补全

`POST /v1/chat/completions` 根据对话历史创建模型响应，兼容 OpenAI Chat Completions API，支持流式和非流式响应。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `model` | `string` | 是 | 模型 ID。 |
| `messages` | object 数组 | 是 | 对话消息列表。 |
| `temperature` | `number` | 否 | 采样温度，默认 `1`，范围 `0` 到 `2`。 |
| `top_p` | `number` | 否 | 核采样参数，默认 `1`，范围 `0` 到 `1`。 |
| `n` | `integer` | 否 | 生成数量，默认 `1`。 |
| `stream` | `boolean` | 否 | 是否流式响应，默认 `false`。 |
| `stream_options` | `object` | 否 | 流式响应选项。 |
| `stop` | string 或 string 数组 | 否 | 停止序列。 |
| `max_tokens` | `integer` | 否 | 最大生成 Token 数。 |
| `max_completion_tokens` | `integer` | 否 | 最大补全 Token 数。 |
| `presence_penalty` | `number` | 否 | 存在惩罚，默认 `0`，范围 `-2` 到 `2`。 |
| `frequency_penalty` | `number` | 否 | 频率惩罚，默认 `0`，范围 `-2` 到 `2`。 |
| `tools` | object 数组 | 否 | 工具调用定义。 |
| `tool_choice` | string 或 object | 否 | 工具选择策略。 |
| `response_format` | `object` | 否 | 响应格式约束。 |
| `seed` | `integer` | 否 | 随机种子。 |
| `reasoning_effort` | `string` | 否 | 推理强度，可取 `low`、`medium`、`high`。 |
| `modalities` | string 数组 | 否 | 多模态输出类型。 |
| `audio` | `object` | 否 | 音频输出配置。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/chat/completions" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [
      { "role": "system", "content": "你是一个简洁的助手。" },
      { "role": "user", "content": "用一句话介绍 New API。" }
    ]
  }'
```

## 响应

典型响应包含 `id`、`object`、`created`、`model`、`choices[]`、`usage` 和 `system_fingerprint`。`choices[].message` 中可能包含 `content`、`tool_calls`、`reasoning_content` 等字段。
