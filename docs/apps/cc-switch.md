---
title: CC Switch 
description: CC Switch 对接 New API 的本地整理指南。
---

# CC Switch - AI CLI 统一管理工具



## 概述

CC Switch 是一款开源、跨平台的 AI CLI 统一管理工具，用于管理 Claude Code、Codex、Gemini CLI 的 Provider 配置、MCP 服务器、系统提示词和 Skills。它支持通过 `ccswitch://` Deep Link 从 New API 令牌管理页导入配置。

## 官方资源

- GitHub：<https://github.com/farion1231/cc-switch>
- Releases：<https://github.com/farion1231/cc-switch/releases>
- 更新日志：<https://github.com/farion1231/cc-switch/blob/main/CHANGELOG.md>
- Web 版本仓库：<https://github.com/cp-yu/cc-switch-web>
- CLI 版本仓库：<https://github.com/thomas-jack/cc-switch-cli>

## 核心能力

| 能力          | 说明                                                                                          |
| ------------- | --------------------------------------------------------------------------------------------- |
| Provider 管理 | 可在 Claude Code、Codex、Gemini 的 API 配置间切换，支持多端点、API Key 管理和延迟测速。       |
| 模型配置      | 支持主模型、Haiku、Sonnet、Opus、Custom 等粒度。                                              |
| MCP 管理      | 统一管理 Claude、Codex、Gemini 三端 MCP 服务器，支持 stdio、HTTP、SSE。                       |
| Prompts 管理  | 管理多套系统提示词，支持 Claude 的 `CLAUDE.md`、Codex 的 `AGENTS.md`、Gemini 的 `GEMINI.md`。 |
| 多平台        | 提供桌面应用、Web 版本和 CLI 版本。                                                           |

## New API 接入方法

### New API 控制台快捷项

可在 New API 控制台的系统设置、聊天设置中添加快捷选项，便于令牌管理页一键填充到 CC Switch：

```json
{
  "CC Switch": "ccswitch"
}
```

### 配置步骤

1. 在 New API 令牌管理页找到需要使用的令牌。
2. 打开令牌下拉菜单，选择 CC Switch。
3. New API 会唤起 CC Switch，并弹出配置窗口。
4. 在弹窗中选择目标应用，支持 Claude、Codex、Gemini。
5. 填写配置名称，例如 `My Claude`。
6. 选择主模型，并按需配置 Haiku、Sonnet、Opus 等模型。
7. 点击打开 CC Switch 导入配置；取消则放弃本次操作。

## 安装方式

| 平台     | 方式                                                                                             |
| -------- | ------------------------------------------------------------------------------------------------ |
| macOS    | 使用 Homebrew cask 安装：`brew tap farion1231/ccswitch` 后执行 `brew install --cask cc-switch`。 |
| Windows  | 从 GitHub Releases 下载 `.msi` 安装包或 `.zip` 便携版。                                          |
| Linux    | 从 GitHub Releases 下载 `.deb` 包或 `.AppImage`；ArchLinux 可使用 `paru -S cc-switch-bin`。      |
| Web 版本 | 下载 `cc-switch-web-linux-x64.tar.gz`，解压后运行 `./cc-switch-web`，默认端口 `17666`。          |

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/cc-switch>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19