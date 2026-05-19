---
title: 模型列表
description: 获取当前可用模型列表。
---

# 模型列表

`GET /v1/models` 用于获取当前可用模型。

该接口会根据请求头自动识别返回格式：

| 请求特征 | 返回格式 |
| --- | --- |
| 携带 `x-api-key` 与 `anthropic-version` | Anthropic 格式 |
| 携带 `x-goog-api-key` 或 `key` 查询参数 | Gemini 格式 |
| 其他情况 | OpenAI 格式 |

## 示例

```bash
curl -X GET "https://one.gloscai.com/v1/models" \
  -H "Authorization: Bearer sk-xxxxxx"
```

## 典型响应字段

| 字段 | 说明 |
| --- | --- |
| `object` | 列表类型，OpenAI 格式通常为 `list`。 |
| `data[].id` | 模型 ID。 |
| `data[].object` | 资源类型，通常为 `model`。 |
| `data[].owned_by` | 模型归属方。 |
