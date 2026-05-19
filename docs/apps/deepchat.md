---
title: DeepChat 
description: DeepChat 对接 New API 的本地整理指南。
---

# DeepChat - 全功能AI Agent客户端



## 概述

DeepChat 是开源、跨平台、商业化友好的全功能 AI Agent 客户端，支持云端与本地模型、MCP 工具调用、Skills、ACP、Agent 集成和远程控制。它适合需要统一管理多个 Provider 和高级 Agent 工作流的用户。

## 官方资源

- 官网：<https://deepchat.thinkinai.xyz/>
- GitHub：<https://github.com/ThinkInAIXYZ/deepchat>
- 下载：<https://deepchat.thinkinai.xyz/#/download>

## New API 控制台快捷项

可在 New API 控制台的系统设置、聊天设置中添加快捷选项：

```json
{
  "DeepChat": "deepchat://provider/install?v=1&data={deepchatConfig}"
}
```

## New API 接入方法

### 方式一：一键导入

1. 在 New API 控制台侧边栏进入令牌管理。
2. 找到需要使用的令牌，在令牌操作中选择 DeepChat。
3. 浏览器唤起 DeepChat 后，确认打开应用。
4. 在 DeepChat 的 Provider 导入预览中确认配置。
5. 打开模型列表，选择 New API 模型开始使用。

### 方式二：手动导入

1. 在 New API 控制台复制 API Key 和站点地址。
2. 在 DeepChat 设置中添加或编辑 New API Provider。
3. 填写 API 地址和 API Key。
4. 打开模型列表，选择 New API 模型开始使用。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/deepchat>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19