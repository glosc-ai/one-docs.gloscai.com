---
title: 内容审查
description: 检查输入内容是否违反使用政策。
---

# 内容审查

`POST /v1/moderations` 检查输入内容是否违反使用政策。内容审查接口是合规工具之一，不能替代业务侧自身的安全治理和上游内容政策要求。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| `input` | string 或 string 数组 | 是 | 待审核文本。 |
| `model` | `string` | 否 | 审查模型 ID。 |

## 示例

```bash
curl -X POST "https://one.gloscai.com/v1/moderations" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "input": "需要审核的文本"
  }'
```

## 响应

响应通常包含 `results[].flagged`、`results[].categories` 和 `results[].category_scores`。
