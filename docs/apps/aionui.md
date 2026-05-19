---
title: AionUi 
description: AionUi 对接 New API 的本地整理指南。
---

# AionUi - 免费开源的桌面办公Agent



## 概述

AionUi 是一款免费、本地、开源的桌面办公 Agent，支持 Gemini CLI、Claude Code、Codex、OpenCode、Qwen Code、Goose CLI、Auggie 等多种 AI 代理。它提供 GUI 界面、WebUI 远程访问、文件管理和实时预览能力，适合把多种 AI 代理统一到一个本地办公工作流中。

## 官方资源

- 官网：<https://www.aionui.com/>
- GitHub：<https://github.com/iOfficeAI/AionUi>
- 下载：<https://github.com/iOfficeAI/AionUi/releases>
- 使用指南：<https://github.com/iOfficeAI/AionUi#-detailed-usage-guide>

## 核心能力

| 能力       | 说明                                                                    |
| ---------- | ----------------------------------------------------------------------- |
| 多会话聊天 | 支持多个会话并保留独立上下文，对话数据本地存储在 SQLite 中。            |
| 多模型支持 | 支持 Gemini、OpenAI、Claude、Qwen、Ollama、LM Studio 等平台或本地模型。 |
| 多代理模式 | 可以同时运行多个 AI 代理，并通过 MCP 管理代理工具和配置。               |
| 文件管理   | 支持文件树浏览、拖拽上传，并可让 AI 协助整理文件。                      |
| 预览面板   | 支持 PDF、Office、代码、Markdown、图片等格式预览，部分格式可实时编辑。  |
| 图像能力   | 可接入图像生成、图像识别和图像编辑模型。                                |
| 多渠道访问 | 支持 WebUI、Telegram、飞书等访问方式，数据保存在本地。                  |

## New API 接入方法

### 参数填写

| 参数       | 填写方式                                                          |
| ---------- | ----------------------------------------------------------------- |
| 提供商类型 | 选择 New API 支持的类型。                                         |
| API 地址   | 填写 New API 站点地址，通常为 `https://<your-newapi-domain>/v1`。 |
| API 密钥   | 粘贴 New API 控制台中创建的 API Key。                             |
| 模型名称   | 选择或填写 New API 中已经配置的模型名称。                         |

请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。

### 配置步骤

1. 在 New API 控制台复制需要使用的 API Key。
2. 打开 AionUi 设置页，进入模型配置 Tab。
3. 点击添加模型，选择 New API 提供商。
4. 填写 API 地址和 API 密钥。
5. 从下拉列表选择需要添加的模型，模型名称应与 New API 中配置的名称一致。
6. 选择合适的请求协议，保存后返回聊天页面。
7. 在聊天页选择刚配置的 New API 模型开始对话。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/aionui>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19