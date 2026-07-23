---
title: 实时语音
description: 建立 OpenAI Realtime 或 SeedASR WebSocket 连接。
---

# 实时语音

## OpenAI Realtime

`GET /v1/realtime` 是 WebSocket 端点，用于实时对话。

### 请求参数

| 参数    | 类型     | 必填 | 说明           |
| ------- | -------- | ---- | -------------- |
| `model` | `string` | 否   | 实时对话模型。 |

### 连接示例

```text
wss://one.gloscai.com/v1/realtime?model=gpt-4o-realtime
```

建立连接时同样需要携带认证信息。成功升级连接后响应状态为 `101`。

## SeedASR 流式语音识别

`GET /api/v3/plan/sauc/bigmodel_nostream` 用于调用火山 Agent Plan 的
SeedASR 流式语音识别：

```text
wss://one.gloscai.com/api/v3/plan/sauc/bigmodel_nostream
```

该端点使用火山二进制 WebSocket 协议，与 `/v1/realtime` 的 OpenAI JSON
事件协议不同，两者不能混用。

### 模型与认证

| 请求头              | 必填 | 说明                                          |
| ------------------- | ---- | --------------------------------------------- |
| `X-Api-Key`         | 是   | GLOSC API Key，例如 `sk-xxxxxx`。             |
| `X-Api-Resource-Id` | 是   | 固定为 `volc.seedasr.sauc.duration`。         |
| `X-Api-Request-Id`  | 建议 | 每次请求使用一个新的 UUID。省略时由网关生成。 |
| `X-Api-Connect-Id`  | 建议 | 连接 UUID，通常与 Request ID 相同。           |
| `X-Api-Sequence`    | 建议 | 初始值为 `-1`。                               |

网关通过 Resource ID 将请求路由到模型
`bytedance/volc.seedasr.sauc.duration`。客户端无需提供火山 API Key；网关会
使用所选火山 Agent Plan 渠道的凭据连接上游。

成功时服务端返回 `101 Switching Protocols`，之后客户端和服务端只交换
二进制帧。

### 二进制帧格式

每个请求帧由以下部分组成，整数均使用大端序：

| 字段         | 长度   | 说明                                             |
| ------------ | ------ | ------------------------------------------------ |
| Header       | 4 字节 | 协议版本、消息类型、序列标志、序列化和压缩方式。 |
| Sequence     | 4 字节 | 有符号 `int32`；最后一个音频包使用负数。         |
| Payload size | 4 字节 | gzip 压缩后 payload 的字节数。                   |
| Payload      | 不定长 | gzip 压缩后的 JSON 或音频数据。                  |

常用 Header：

| 消息                | Header 十六进制 | 说明                         |
| ------------------- | --------------- | ---------------------------- |
| Full client request | `11 11 11 00`   | 正 sequence、JSON、gzip。    |
| Audio request       | `11 21 11 00`   | 正 sequence、gzip 音频分片。 |
| Last audio request  | `11 23 11 00`   | 负 sequence，表示发送结束。  |

### 会话流程

1. 建立 WebSocket 连接并携带认证请求头。
2. 发送 Full client request，sequence 从 `1` 开始。
3. 收到服务端初始化响应后开始发送音频。
4. 将 16 kHz、16-bit、单声道 PCM WAV 按 200 ms 分片发送；每发送一片递增
   sequence，并按真实音频时长控制发送间隔。
5. 最后一片使用负 sequence 和 `NEG_WITH_SEQUENCE` 标记。
6. 持续接收识别结果；响应 Header 的 flags 包含 `0x02` 时表示最终结果。
7. 读取 `result.text`，然后正常关闭连接。

Full client request 中的音频配置应与实际输入一致：

```json
{
  "user": { "uid": "demo-user" },
  "audio": {
    "format": "wav",
    "codec": "raw",
    "rate": 16000,
    "bits": 16,
    "channel": 1
  },
  "request": {
    "model_name": "bigmodel",
    "enable_itn": true,
    "enable_punc": true,
    "enable_ddc": true,
    "enable_nonstream": false,
    "show_utterances": true,
    "result_type": "full"
  }
}
```

可直接运行的 Python 示例见[语音 API](./speech.md#流式语音识别)。
