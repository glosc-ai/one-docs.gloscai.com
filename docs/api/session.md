---
title: 实时语音
description: 建立 WebSocket 连接用于实时对话。
---

# 实时语音

`GET /v1/realtime` 是 WebSocket 端点，用于实时对话。

## 请求参数

| 参数    | 类型     | 必填 | 说明           |
| ------- | -------- | ---- | -------------- |
| `model` | `string` | 否   | 实时对话模型。 |

## 连接示例

```text
wss://api.example.com/v1/realtime?model=gpt-4o-realtime
```

建立连接时同样需要携带认证信息。成功升级连接后响应状态为 `101`。
