---
title: 认证与公共请求
description: New API AI 模型接口的认证头、Base URL 和公共调用约定。
---

# 认证与公共请求

除特别说明外，请求需要携带 Bearer Token：

```http
Authorization: Bearer sk-xxxxxx
Content-Type: application/json
```

常用 Base URL：

```text
https://one.gloscai.com/v1
```

私有化部署时，将域名替换为自己的 New API 服务地址即可。

## 请求格式

| 项 | 说明 |
| --- | --- |
| 认证 | `Authorization: Bearer sk-xxxxxx` |
| JSON 请求体 | 使用 `Content-Type: application/json`。 |
| 表单请求体 | 个别兼容接口可能使用 `multipart/form-data`；视频生成 API 推荐使用 JSON。 |
| 兼容格式 | OpenAI 格式为主，部分接口兼容 Anthropic、Gemini、Sora、Kling、即梦等格式。 |
