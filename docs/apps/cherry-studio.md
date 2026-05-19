---
title: Cherry Studio
description: Cherry Studio 对接 New API 的本地整理指南。
---

# Cherry Studio - 桌面 AI 客户端



## 概述

Cherry Studio 是面向专业用户的桌面 AI 客户端，内置多种 AI 助手，支持多模型对话和图像生成等工作场景。New API 支持通过 Deep Link 把令牌和 Provider 信息填入 Cherry Studio。

## 官方资源

- 官网：<https://cherry-ai.com/>
- 下载：<https://cherry-ai.com/download>
- 官方文档：<https://docs.cherry-ai.com/>

## New API 控制台快捷项

可在 New API 控制台的系统设置、聊天设置中添加快捷选项：

```json
{
  "Cherry Studio": "cherrystudio://providers/api-keys?v=1&data={cherryConfig}"
}
```

添加后，可在令牌管理页通过对应入口一键填充 Cherry Studio。

## New API 接入方法

### 参数填写

| 参数       | 填写方式                              |
| ---------- | ------------------------------------- |
| 提供商类型 | 选择 New API 支持的类型。             |
| API 地址   | 填写 New API 站点地址。               |
| API 密钥   | 粘贴 New API 控制台中创建的 API Key。 |
| 模型       | 添加或选择 New API 中已配置的模型。   |

请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。

### 配置步骤

1. 在 New API 控制台复制 API Key，或使用令牌管理页的 Cherry Studio 快捷入口。
2. 在 Cherry Studio 中添加 New API Provider。
3. 填写 API 地址和 API Key。
4. 添加需要使用的模型。
5. 返回聊天页面，切换到 New API 模型开始对话。

## 图像模型使用

Cherry Studio 可使用通过 New API 暴露的图像模型。先添加支持图像生成的模型，再在聊天或绘图入口中选择该模型发起生成请求。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/cherry-studio>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19