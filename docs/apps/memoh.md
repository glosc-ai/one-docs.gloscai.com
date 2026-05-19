---
title: Memoh 
description: Memoh 对接 New API 的本地整理指南。
---

# Memoh - 容器化 AI 智能体平台



## 概述

Memoh 是开源自托管 AI 智能体平台。每个机器人运行在独立容器中，拥有持久化记忆和独立文件系统，支持 Telegram、Discord、飞书、QQ、Matrix、企业微信、微信、邮件和 Web UI 等渠道。

## 官方资源

- 官网：<https://memoh.sh/>
- 官方文档：<https://docs.memoh.ai/>
- GitHub：<https://github.com/memohai/Memoh>

## 核心能力

| 能力         | 说明                                                                                 |
| ------------ | ------------------------------------------------------------------------------------ |
| 容器化隔离   | 每个机器人运行在独立 containerd 容器中，支持专属文件系统、网络、快照和数据导入导出。 |
| 记忆引擎     | 支持事实抽取、混合检索、上下文加载、记忆压缩和重建。                                 |
| 多渠道       | 支持 Telegram、Discord、飞书、QQ、Matrix、企业微信、微信、邮件和 Web UI。            |
| MCP          | 支持 HTTP、SSE、Stdio、OAuth，每个机器人可独立管理 MCP 连接。                        |
| 浏览器自动化 | 内置 Playwright 驱动的无头浏览器，支持浏览、表单填写和截图。                         |
| Web 管理面板 | 基于 Vue 3 和 Tailwind CSS，支持流式对话、工具调用可视化和文件管理。                 |

## 快速安装

Memoh 基于 Docker 部署。官方提供一键安装方式：

```bash
curl -fsSL https://memoh.sh | sudo sh
```

也可以手动安装：

```bash
git clone --depth 1 https://github.com/memohai/Memoh.git
cd Memoh
cp conf/app.docker.toml config.toml
# 编辑 config.toml 配置文件
sudo docker compose up -d
```

启动后访问 `http://localhost:8082`，默认账号密码为 `admin` / `admin123`。

## New API 接入方法

Memoh 支持接入任何 OpenAI 兼容的模型提供商，可以通过 New API 统一管理和访问多种模型服务。

### 配置步骤

1. 在 New API 控制台的令牌管理中创建 API Key，并复制密钥。
2. 登录 Memoh Web 管理面板，进入提供商管理页面。
3. 选择 New API 提供商。
4. 填写 API Base URL，例如 `https://api.example.com/v1`；本地部署可填写 `http://localhost:3000/v1`。
5. 填写 API Key 并保存。
6. 进入模型管理页面，自动导入或手动添加需要使用的模型。
7. 进入机器人设置，在模型配置中将默认聊天模型切换为 New API 提供商下的模型。
8. 保存后即可通过各渠道与机器人对话，请求会通过 New API 转发。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/memoh>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19