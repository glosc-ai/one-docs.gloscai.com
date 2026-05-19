---
title: 文本转语音
description: 将文本转换为音频。
---

# 文本转语音

`POST /v1/audio/speech` 将文本转换为音频。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `model` | `string` | 是 | TTS 模型 ID。 |
| `input` | `string` | 是 | 待转换文本，长度不超过 4096。 |
| `voice` | `string` | 是 | 可选 `alloy`、`echo`、`fable`、`onyx`、`nova`、`shimmer`。 |
| `response_format` | `string` | 否 | 默认 `mp3`，可选 `mp3`、`opus`、`aac`、`flac`、`wav`、`pcm`。 |
| `speed` | `number` | 否 | 语速，默认 `1`，范围 `0.25` 到 `4`。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/audio/speech" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "tts-1",
    "input": "你好，欢迎使用 New API。",
    "voice": "alloy"
  }' \
  --output speech.mp3
```

## 响应

成功响应为音频内容，例如 `audio/mpeg`。
