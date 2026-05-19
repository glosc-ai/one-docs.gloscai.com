---
title: 文档重排序
description: 根据查询文本对文档列表做相关性重排序。
---

# 文档重排序

`POST /v1/rerank` 根据查询文本对文档列表做相关性重排序。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `model` | `string` | 是 | 重排序模型 ID。 |
| `query` | `string` | 是 | 查询文本。 |
| `documents` | string 或 object 数组 | 是 | 待排序文档列表。 |
| `top_n` | `integer` | 否 | 返回前 N 个结果。 |
| `return_documents` | `boolean` | 否 | 是否返回文档内容，默认 `false`。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/rerank" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "rerank-english-v2.0",
    "query": "用户登录失败如何排查",
    "documents": [
      "检查账号状态和密码是否正确",
      "配置图像生成参数",
      "查看系统错误日志"
    ],
    "top_n": 2
  }'
```

## 响应

响应通常包含 `results[].index`、`results[].relevance_score`、可选 `results[].document` 和 `meta`。
