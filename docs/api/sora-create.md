---
title: 视频生成 API
description: 使用 OpenAI 兼容接口创建、查询和下载异步视频生成任务。
---

# 视频生成 API

视频生成是异步任务。客户端先通过 `POST /v1/videos` 创建任务，保存响应中的公开任务 ID，再定期查询任务状态；任务完成后，可使用结果 URL 或网关下载接口获取视频。

## 接口概览

| 操作 | 方法与路径 | 说明 |
| --- | --- | --- |
| 创建任务 | `POST /v1/videos` | 提交文生视频或图生视频任务。 |
| 查询任务 | `GET /v1/videos/{task_id}` | 使用公开任务 ID 查询进度和结果。 |
| 获取视频 | `GET /v1/videos/{task_id}/content` | 由网关鉴权并代理返回视频内容。 |

所有接口都需要使用 Glosc AI One 令牌，而不是上游服务的 API Key：

```http
Authorization: Bearer <TOKEN>
```

下文示例使用以下环境变量：

```bash
export BASE_URL="https://one.gloscai.com"
export TOKEN="sk-xxxxxx"
```

## 创建任务

```http
POST /v1/videos
Authorization: Bearer <TOKEN>
Content-Type: application/json
```

### 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `model` | `string` | 是 | 模型 ID，例如 `doubao-seedance-2.0`。网关会根据渠道配置应用模型映射。 |
| `prompt` | `string` | 是 | 视频内容描述，不能是空字符串。 |
| `seconds` | `string` | 否 | 视频时长（秒）。Agent Plan 渠道推荐使用此字段，例如 `"5"`。最大值为 `3600`。 |
| `image` | `string` | 否 | 单张参考图片 URL；传入后按图生视频任务处理。 |
| `images` | `string[]` | 否 | 多张参考图片 URL。 |
| `metadata` | `object` | 否 | 传递给上游的视频生成扩展参数。 |

::: warning 时长字段
Agent Plan 渠道请优先传入字符串形式的 `seconds`。顶层 `duration` 当前会参与校验和计费，但不会正确转发给上游；需要使用 `duration` 时，请放在 `metadata.duration` 中。
:::

### Metadata 参数

常用的 `metadata` 字段如下。字段是否可用以及允许的取值范围仍取决于所选模型。

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| `resolution` | `string` | 输出分辨率，例如 `720p`。 |
| `ratio` | `string` | 输出宽高比，例如 `16:9`。 |
| `generate_audio` | `boolean` | 是否生成音频。 |
| `watermark` | `boolean` | 是否添加水印。 |
| `duration` | `integer` | 上游任务时长（秒），范围为 `1` 到 `3600`。顶层已传 `seconds` 时，以 `seconds` 为准。 |
| `seed` | `integer` | 随机种子。 |
| `frames` | `integer` | 生成帧数。 |
| `camera_fixed` | `boolean` | 是否固定镜头。 |
| `callback_url` | `string` | 上游任务回调地址。 |
| `service_tier` | `string` | 上游服务等级。 |
| `content` | `array` | 原始上游内容数组，可用于图片、视频等多模态输入。详见下方说明。 |

此外，适配器还支持 `return_last_frame`、`execution_expires_after`、`draft`、`tools`、`safety_identifier` 和 `priority` 等 Agent Plan 参数。

使用 `metadata.content` 时，其结构会作为上游 `content` 传递。网关会移除其中所有 `type: "text"` 的项目，并用顶层 `prompt` 追加唯一的文本项目，因此提示词应始终写在顶层 `prompt` 中。例如：

```json
{
  "metadata": {
    "content": [
      {
        "type": "image_url",
        "image_url": {
          "url": "https://example.com/reference.png"
        }
      }
    ]
  }
}
```

### 请求示例

下面的请求创建一个 5 秒、16:9、720p 的图生视频任务：

```bash
curl "$BASE_URL/v1/videos" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "doubao-seedance-2.0",
    "prompt": "海边日落，电影镜头，缓慢推进",
    "seconds": "5",
    "image": "https://example.com/reference.png",
    "metadata": {
      "resolution": "720p",
      "ratio": "16:9",
      "generate_audio": true,
      "watermark": false
    }
  }'
```

文生视频时省略 `image` 和 `images` 即可。

### 创建响应

创建成功后返回 HTTP `200`。`id` 与兼容字段 `task_id` 当前值相同，后续请求应使用 `id`：

```json
{
  "id": "task_xxxxxxxxx",
  "task_id": "task_xxxxxxxxx",
  "object": "video",
  "model": "doubao-seedance-2.0",
  "status": "queued",
  "progress": 0,
  "created_at": 1783650000
}
```

`task_xxxxxxxxx` 是网关生成的公开任务 ID，不是火山引擎的上游任务 ID。

## 查询任务

使用创建响应中的公开任务 ID 查询：

```http
GET /v1/videos/task_xxxxxxxxx
Authorization: Bearer <TOKEN>
```

```bash
curl "$BASE_URL/v1/videos/task_xxxxxxxxx" \
  -H "Authorization: Bearer $TOKEN"
```

Agent Plan 任务由后台约每 15 秒同步一次，并非实时查询。客户端不需要以更高频率轮询；建议每 15 秒查询一次，直到进入 `completed` 或 `failed` 终态。

| `status` | `progress` 示例 | 说明 |
| --- | --- | --- |
| `queued` | `10` | 任务正在排队。 |
| `in_progress` | `30` 或 `50` | 任务正在生成。 |
| `completed` | `100` | 任务完成，可获取视频。 |
| `failed` | `100` | 任务失败，错误信息位于 `error`。 |

任务完成后的响应类似：

```json
{
  "id": "task_xxxxxxxxx",
  "task_id": "task_xxxxxxxxx",
  "object": "video",
  "model": "doubao-seedance-2.0",
  "status": "completed",
  "progress": 100,
  "created_at": 1783650000,
  "completed_at": 1783650030,
  "metadata": {
    "url": "https://example.com/generated-video.mp4"
  }
}
```

任务失败时，响应会包含错误对象：

```json
{
  "status": "failed",
  "progress": 100,
  "error": {
    "code": "upstream_error_code",
    "message": "上游返回的错误信息"
  }
}
```

## 获取视频

任务状态为 `completed` 后，可以直接使用 `metadata.url`，也可以通过网关下载：

```bash
curl "$BASE_URL/v1/videos/task_xxxxxxxxx/content" \
  -H "Authorization: Bearer $TOKEN" \
  --output video.mp4
```

网关会校验令牌与任务归属，再代理上游视频内容。任务不存在、任务不属于当前用户，或任务尚未完成时，不会返回视频文件。

## 字段转换

使用 Agent Plan 渠道时，网关按以下规则转换请求：

| 客户端字段 | Agent Plan 字段 |
| --- | --- |
| `model` | `model`；应用渠道模型映射后发送。 |
| `prompt` | `content[]` 中的 `type: "text"` 项。 |
| `image` / `images` | `content[]` 中的 `type: "image_url"` 项。 |
| `seconds` | `duration`。 |
| `metadata.content` | 上游 `content`；其中的文本项会由顶层 `prompt` 替换。 |
| `metadata.resolution` | `resolution`。 |
| `metadata.ratio` | `ratio`。 |
| `metadata.generate_audio` | `generate_audio`。 |
| `metadata.watermark` | `watermark`。 |
| 其他受支持的 `metadata` | 同名传递，例如 `callback_url`、`service_tier`、`seed`、`frames`、`camera_fixed`。 |

Agent Plan 上游状态会转换为统一的视频状态：

| Agent Plan 状态 | 客户端状态 |
| --- | --- |
| `pending` / `queued` | `queued` |
| `processing` / `running` | `in_progress` |
| `succeeded` | `completed` |
| `failed` / `cancelled` / `canceled` / `deleted` | `failed` |

## 当前限制

- 请使用 JSON 请求和图片 URL。文件形式的 `input_reference` 当前不会转换给 Agent Plan；图生视频请使用 `image`、`images` URL 或 `metadata.content`。
- 用户 API 当前只提供创建、单任务查询和视频内容获取，不提供任务列表及删除接口。
- Agent Plan 渠道暂时应配置为单 Key。管理员任务列表接口会拒绝多 Key 渠道。
- 管理员接口 `/api/channel/:id/agent-plan/video/tasks` 查询或删除的是火山引擎上游任务，使用上游任务 ID，不接受公开的 `task_xxx` ID。

## Agent Plan 链路

创建请求通过令牌认证后，网关会根据模型、用户分组和渠道状态选择 Agent Plan 渠道，校验提示词与时长，应用模型映射并完成预扣费。随后请求被转换并发送至：

```http
POST https://ark.cn-beijing.volces.com/api/plan/v3/contents/generations/tasks
Authorization: Bearer <Agent Plan API Key>
```

渠道只配置根地址时，网关会自动追加 `/api/plan/v3`；配置为 `/api/v3` 时会规范化为 `/api/plan/v3`。上游任务创建成功后，网关会生成独立的公开任务 ID，完成扣费结算、消费日志记录和任务入库。

后台同步任务使用上游任务 ID 查询状态：

```http
GET /api/plan/v3/contents/generations/tasks/{upstream_task_id}
```
