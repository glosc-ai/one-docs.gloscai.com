---
title: 嵌入向量
description: 将文本转换为向量嵌入。
---

# 嵌入向量

`POST /v1/embeddings` 将文本转换为向量嵌入。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `model` | `string` | 是 | 嵌入模型 ID。 |
| `input` | string 或 string 数组 | 是 | 待嵌入文本。 |
| `encoding_format` | `string` | 否 | 默认 `float`，可选 `float` 或 `base64`。 |
| `dimensions` | `integer` | 否 | 输出向量维度。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/embeddings" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding-ada-002",
    "input": "需要向量化的文本"
  }'
```

## 响应

响应通常包含 `data[].embedding`、`data[].index`、`model` 和 `usage`。
