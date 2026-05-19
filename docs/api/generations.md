---
title: 图像生成
description: 根据提示词生成图像。
---

# 图像生成

`POST /v1/images/generations/` 根据提示词生成图像。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `prompt` | `string` | 是 | 图像描述提示词。 |
| `model` | `string` | 否 | 可使用 `dall-e-2`、`dall-e-3` 或 `gpt-image-1` 等。 |
| `n` | `integer` | 否 | 生成数量，通常为 `1` 到 `10`；`dall-e-3` 仅支持 `1`。 |
| `size` | `string` | 否 | 图像尺寸，不同模型支持的尺寸不同。 |
| `background` | `string` | 否 | `gpt-image-1` 支持透明、非透明或自动背景。 |
| `moderation` | `string` | 否 | `gpt-image-1` 的内容审核级别。 |
| `quality` | `string` | 否 | 输出质量。 |
| `style` | `string` | 否 | 图像风格。 |
| `user` | `string` | 否 | 终端用户标识。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/images/generations/" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-image-1",
    "prompt": "一张干净的产品文档封面图",
    "size": "1024x1024"
  }'
```

## 响应

响应通常包含 `data[].b64_json` 或 `data[].url`，以及可选的 token 用量信息。
