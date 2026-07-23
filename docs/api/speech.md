---
title: 语音
description: 使用文本转语音和 SeedASR 流式语音识别。
---

# 语音

## 文本转语音

`POST /v1/audio/speech` 将文本转换为音频。

### 请求参数

| 参数              | 类型     | 必填 | 说明                                                          |
| ----------------- | -------- | ---- | ------------------------------------------------------------- |
| `model`           | `string` | 是   | TTS 模型 ID。                                                 |
| `input`           | `string` | 是   | 待转换文本，长度不超过 4096。                                 |
| `voice`           | `string` | 是   | 可选 `alloy`、`echo`、`fable`、`onyx`、`nova`、`shimmer`。    |
| `response_format` | `string` | 否   | 默认 `mp3`，可选 `mp3`、`opus`、`aac`、`flac`、`wav`、`pcm`。 |
| `speed`           | `number` | 否   | 语速，默认 `1`，范围 `0.25` 到 `4`。                          |

### 示例

```bash
curl -X POST "https://one.gloscai.com/v1/audio/speech" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "bytedance/seed-tts-2.0",
    "input": "你好，欢迎使用 GLOSC AI。",
    "voice": "alloy"
  }' \
  --output speech.mp3
```

### 响应

成功响应为音频内容，例如 `audio/mpeg`。

## 流式语音识别

SeedASR 使用火山二进制 WebSocket 协议，不使用 OpenAI Realtime 的 JSON
事件协议。

| 配置项         | 值                                                         |
| -------------- | ---------------------------------------------------------- |
| 模型           | `bytedance/volc.seedasr.sauc.duration`                     |
| WebSocket 地址 | `wss://one.gloscai.com/api/v3/plan/sauc/bigmodel_nostream` |
| Resource ID    | `volc.seedasr.sauc.duration`                               |
| 推荐音频       | 16 kHz、16-bit、单声道 PCM WAV                             |
| 推荐分片       | 200 ms，即每片 6400 字节                                   |

安装 Python WebSocket 客户端：

```bash
pip install "websockets>=11,<16"
```

下面的示例将 WAV 文件按真实时长流式发送，并打印最终识别结果：

```python
import gzip
import json
import struct
import time
import uuid
import wave
from pathlib import Path

from websockets.sync.client import connect


WS_URL = "wss://one.gloscai.com/api/v3/plan/sauc/bigmodel_nostream"
API_KEY = "sk-xxxxxx"
AUDIO_FILE = Path("speech.wav")
SAMPLE_RATE = 16000
BYTES_PER_CHUNK = 6400  # 16 kHz * 16-bit * mono * 200 ms


def encode_message(message_type, flags, sequence, payload):
    compressed = gzip.compress(payload)
    header = bytes([
        0x11,                         # version 1, 4-byte header
        (message_type << 4) | flags,
        0x11,                         # JSON serialization, gzip compression
        0x00,
    ])
    return (
        header
        + struct.pack(">i", sequence)
        + struct.pack(">I", len(compressed))
        + compressed
    )


def full_request(sequence):
    payload = {
        "user": {"uid": f"demo-{uuid.uuid4().hex[:12]}"},
        "audio": {
            "format": "wav",
            "codec": "raw",
            "rate": SAMPLE_RATE,
            "bits": 16,
            "channel": 1,
        },
        "request": {
            "model_name": "bigmodel",
            "enable_itn": True,
            "enable_punc": True,
            "enable_ddc": True,
            "enable_nonstream": False,
            "show_utterances": True,
            "result_type": "full",
        },
    }
    return encode_message(
        0x01, 0x01, sequence,
        json.dumps(payload, ensure_ascii=False).encode("utf-8"),
    )


def audio_request(sequence, audio, is_last):
    # 最后一帧使用负 sequence 和 NEG_WITH_SEQUENCE 标记。
    return encode_message(
        0x02,
        0x03 if is_last else 0x01,
        -sequence if is_last else sequence,
        audio,
    )


def decode_response(message):
    header_size = (message[0] & 0x0F) * 4
    message_type = message[1] >> 4
    flags = message[1] & 0x0F
    compression = message[2] & 0x0F
    offset = header_size

    if flags & 0x01:  # sequence
        offset += 4
    if flags & 0x04:  # event
        offset += 4

    if message_type == 0x0F:
        code = struct.unpack(">i", message[offset:offset + 4])[0]
        size = struct.unpack(">I", message[offset + 4:offset + 8])[0]
        payload = message[offset + 8:offset + 8 + size]
        if compression == 0x01 and payload:
            payload = gzip.decompress(payload)
        raise RuntimeError(f"SeedASR error {code}: {payload.decode(errors='replace')}")

    size = struct.unpack(">I", message[offset:offset + 4])[0]
    payload = message[offset + 4:offset + 4 + size]
    if compression == 0x01 and payload:
        payload = gzip.decompress(payload)
    data = json.loads(payload.decode("utf-8")) if payload else {}
    return data, bool(flags & 0x02)


with wave.open(str(AUDIO_FILE), "rb") as wav:
    assert wav.getframerate() == SAMPLE_RATE
    assert wav.getsampwidth() == 2
    assert wav.getnchannels() == 1

wav_data = AUDIO_FILE.read_bytes()
request_id = str(uuid.uuid4())
headers = {
    "X-Api-Key": API_KEY,
    "X-Api-Resource-Id": "volc.seedasr.sauc.duration",
    "X-Api-Request-Id": request_id,
    "X-Api-Connect-Id": request_id,
    "X-Api-Sequence": "-1",
}

with connect(WS_URL, additional_headers=headers) as websocket:
    sequence = 1
    websocket.send(full_request(sequence))
    initial = websocket.recv(timeout=15)
    if not isinstance(initial, bytes):
        raise RuntimeError("SeedASR returned a non-binary response")
    decode_response(initial)

    sequence += 1
    chunks = [
        wav_data[offset:offset + BYTES_PER_CHUNK]
        for offset in range(0, len(wav_data), BYTES_PER_CHUNK)
    ]
    for index, chunk in enumerate(chunks):
        is_last = index == len(chunks) - 1
        websocket.send(audio_request(sequence, chunk, is_last))
        if not is_last:
            sequence += 1
            time.sleep(0.2)

    final_text = ""
    while True:
        message = websocket.recv(timeout=15)
        if not isinstance(message, bytes):
            continue
        data, is_final = decode_response(message)
        result = data.get("result", {})
        if result.get("text"):
            final_text = result["text"]
            print(final_text)
        if is_final:
            break

    if not final_text:
        raise RuntimeError("SeedASR did not return transcription text")
```

网关令牌放在 `X-Api-Key` 中。它是 GLOSC API Key，不是火山控制台的
App Key、Access Key 或 Secret Key。完整的连接头和帧格式说明见
[实时语音](./session.md#seedasr-流式语音识别)。
