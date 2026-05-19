---
title: AstrBot
description: AstrBot 对接 New API 的本地整理指南。
---

# AstrBot - Agent 聊天机器人



## 概述

AstrBot 是开源的一站式 Agent 聊天机器人平台，可将大模型能力接入 QQ、飞书、钉钉、企业微信等即时通讯软件，适合搭建个人 AI 伙伴、智能客服、自动化助手和企业知识库。

## 官方资源

- 官网：<https://astrbot.app/>
- 文档：<https://docs.astrbot.app/>
- GitHub：<https://github.com/astrbotdevs/astrbot>

## New API 接入方法

AstrBot 支持将 New API 配置为模型提供商。New API 兼容 OpenAI Chat Completions 和 Responses 接口，因此在 AstrBot 中可通过 OpenAI 提供商入口进行配置。

### 配置步骤

1. 在 New API 控制台注册并登录。
2. 进入控制台的令牌管理页面，点击添加令牌。
3. 选择适当权限后创建 API Key，并复制密钥。
4. 打开 AstrBot 管理面板，进入模型提供商页面。
5. 点击新增模型提供商，选择 OpenAI。
6. 将 API Base URL 设置为 New API 接口地址。本地部署示例：`http://localhost:3000/v1`。
7. 将 API Key 填入对应字段并保存。
8. 进入配置文件页面，在模型一节中把默认聊天模型切换为刚创建的 New API 提供商。
9. 保存后即可通过 AstrBot 使用 New API 提供的模型服务。

请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/astrbot>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19