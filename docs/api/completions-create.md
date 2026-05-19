---
title: 文本补全
description: 基于提示词创建传统文本补全。
---

# 文本补全

`POST /v1/completions` 基于提示词创建传统文本补全。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `model` | `string` | 是 | 模型 ID。 |
| `prompt` | string 或 string 数组 | 是 | 补全提示词。 |
| `max_tokens` | `integer` | 否 | 最大生成 Token 数。 |
| `temperature` | `number` | 否 | 采样温度。 |
| `top_p` | `number` | 否 | 核采样参数。 |
| `n` | `integer` | 否 | 生成数量。 |
| `stream` | `boolean` | 否 | 是否流式响应。 |
| `stop` | string 或 string 数组 | 否 | 停止序列。 |
| `suffix` | `string` | 否 | 补全后缀。 |
| `echo` | `boolean` | 否 | 是否回显提示词。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/completions" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo-instruct",
    "prompt": "写一个产品发布标题"
  }'
```

## 响应

响应通常包含 `choices[].text`、`choices[].finish_reason` 和 `usage`。
