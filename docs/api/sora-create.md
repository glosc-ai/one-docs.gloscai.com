---
title: 视频生成
description: 创建 OpenAI 兼容的视频生成任务。
---

# 视频生成

`POST /v1/videos` 是 OpenAI 兼容的视频生成接口，Sora 格式页面使用该端点创建视频任务。

## 请求参数

| 参数              | 类型      | 必填 | 说明                                                          |
| ----------------- | --------- | ---- | ------------------------------------------------------------- |
| `model`           | `string`  | 否   | 模型或风格 ID。                                               |
| `prompt`          | `string`  | 否   | 文本描述提示词。                                              |
| `image`           | `string`  | 否   | 图片输入，支持 URL 或 Base64。                                |
| `duration`        | `number`  | 否   | 视频时长，单位秒。                                            |
| `width`           | `integer` | 否   | 视频宽度。                                                    |
| `height`          | `integer` | 否   | 视频高度。                                                    |
| `fps`             | `integer` | 否   | 视频帧率。                                                    |
| `seed`            | `integer` | 否   | 随机种子。                                                    |
| `n`               | `integer` | 否   | 生成数量。                                                    |
| `response_format` | `string`  | 否   | 响应格式。                                                    |
| `user`            | `string`  | 否   | 终端用户标识。                                                |
| `metadata`        | `object`  | 否   | 扩展参数，如 `negative_prompt`、`style`、`quality_level` 等。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/videos" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -F "model=sora" \
  -F "prompt=一段简洁的产品演示视频" \
  -F "duration=5"
```

## 响应

响应通常包含 `id`、`object`、`model`、`status`、`progress`、`created_at`、`completed_at`、`expires_at`、`size`、`error` 和 `metadata`。
