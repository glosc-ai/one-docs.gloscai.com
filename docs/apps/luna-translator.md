---
title: LunaTranslator 
description: LunaTranslator 对接 New API 的本地整理指南。
---

# LunaTranslator - 开源 GalGame 翻译器



## 概述

LunaTranslator 是开源免费的视觉小说翻译器，支持 HOOK、OCR、内嵌翻译、语言学习、语音合成和多种大模型翻译接口。通过 New API 可统一接入可用的大模型翻译能力。

## 官方资源

- GitHub：<https://github.com/HIllya51/LunaTranslator>
- 文档：<https://docs.lunatranslator.org/zh/README.html>
- 大模型翻译接口说明：<https://docs.lunatranslator.org/zh/guochandamoxing.html>

## 功能支持

| 功能        | 说明                                                       |
| ----------- | ---------------------------------------------------------- |
| HOOK        | 主要通过 HOOK 提取游戏文本，适配常见和冷门视觉小说。       |
| 内嵌翻译    | 部分游戏可直接把译文内嵌到游戏中。                         |
| 模拟器 HOOK | 支持读取 NS、PSP、PSV、PS2 等模拟器游戏文本。              |
| OCR         | 内置较高精度 OCR，也支持多种在线和离线 OCR 引擎。          |
| 翻译接口    | 支持传统翻译、大语言模型翻译和离线翻译。                   |
| 学习辅助    | 支持日语分词、假名注音、AnkiConnect 和 Yomitan 插件。      |
| 语音能力    | 支持在线和离线语音合成，Windows 10/11 可使用系统语音识别。 |

## 安装方式

请在 LunaTranslator 官方文档的下载、启动和更新页面获取安装包：<https://docs.lunatranslator.org/zh/README.html>。

## 在 LunaTranslator 接入 New API

请使用自己部署的 New API，或确认服务方具备合法上游授权和合规义务。不要将来源不明的 API 地址或密钥接入生产环境。

### New API 控制台快捷项

可在 New API 控制台的系统设置、聊天设置中添加快捷选项：

```json
{
  "LunaTranslator": "lunatranslator://llmapi/base64?data={cheryConfig}"
}
```

### 一键配置

1. 在 New API 控制台的系统设置、聊天设置中添加 LunaTranslator 快捷项。
2. 进入 New API 控制台的令牌管理页面。
3. 找到要用于 LunaTranslator 的令牌，在聊天按钮旁的下拉选项中选择 LunaTranslator。
4. 浏览器会跳转到 LunaTranslator，并自动写入 API 地址和 API Key。
5. 在 LunaTranslator 的设置、翻译设置、大模型中找到新增的大模型接口配置并点击编辑。
6. 点击模型下拉框旁的刷新按钮，获取 New API 模型列表。
7. 选择或输入模型名称，确认保存。
8. 确认 New API 大模型接口旁的开关已经启用。

### 手动配置

1. 在 New API 控制台的令牌管理页面复制 API Key。
2. 在 LunaTranslator 的设置、翻译设置、大模型中选择添加。
3. 复制大模型通用接口模板，新增接口。
4. 在新增接口中填写 API 地址和 API Key。
5. 刷新模型列表，选择或输入模型名称。
6. 保存后打开 New API 接口开关即可开始使用。

## 来源与维护

- 来源页面：<https://www.newapi.ai/zh/docs/apps/luna-translator>
- 官方页面标注最后更新：2026/5/12
- 本地整理日期：2026/5/19