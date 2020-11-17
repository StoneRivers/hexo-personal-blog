---
title: HTTP权威指南读书笔记 (1) - 概述
date: 2020-09-08 09:52:20
tags:
 - 网络协议
 - 读书笔记
categories:
 - 理论学习
link_title: http-overview
---
HTTP协议构建在可靠的数据传输协议（TCP）至上。用于Web客户端向Web服务器请求Web资源。

## 1 媒体类型

Web资源可能是各种类型的静态文件，也可以是动态产生的内容数据。HTTP使用MIME type 区分这些数据的类型。

MIME type（Multipurpose Internet Mail Extension，多用途因特网邮件扩展）最初设计是为邮件报文服务的，后HTTP也采纳这一套类型管理方式。

HTTP服务器会为所有的HTTP对象附加一个MIME type，用于指导HTTP客户端处理收到的HTTP资源。比如：
<!-- more -->
- 显示图片文件
- 解析并格式化 HTML 文件
- 通过计算机声卡播放音频文件
- 或者运行外部插件软件来处理特殊格式的数据

MIME type的格式是两段：`父类型/子类型` 。举例：

- text/html：HTML文本。
- text/plain：ASCII文本。
- image/jpeg：JPEG图片。
- video/quicktime：QuickTime电影。
- application/vnd.ms-powerpoint：PowerPoint 演示文件。

## 2 统一资源标示符URI

Web服务器上的资源都要有一个统一的标识，这样客户端就能通过这个标识去访问自己想要的资源了。这个就是**统一资源标识符**（Uniform Resource Identifier，URI）。

URI分为两种形式：

- URL（Uniform Resource Location）：描述某个资源的特定位置，用于从精确固定的位置获取资源。
- URN（Uniform Resource Name）：作为特定内容的唯一名称使用，与资源的位置无关。

## 3 HTTP方法

HTTP支持不同的请求命令，称为HTTP方法，每条报文都会指明方法，指导服务器进行相应的动作。方法共有9种，前6个较为常用。

- GET
- PUT
- DELETE
- POST
- HEAD
- OPTIONS
- TRACE
- CONNECT
- PATCH

## 4 HTTP状态码

每条HTTP响应报文都会携带一个状态码，用于告知客户端请求是否成功。状态码是一个三位的整数。一些常见的状态码：

- 200：正确。
- 302：资源重定向。
- 404：无法找到资源。

## 5 HTTP报文

HTTP报文不论是请求报文还是响应报文，都分为三部分：

1. 起始行：报文的第一行，请求报文中主要用来说明要做什么。响应报文中说明出现了什么情况。
2. 首部字段：一行一个key-value形式的首部，用`:`分隔。首部用一个空行结束。
3. 主体：空行之后的内容就是主体了。

## 6 HTTP协议与 TCP/IP 协议的交互

HTTP下层依赖的是TCP/IP协议，TCP/IP需要的两个要素是 IP & 端口号。

HTTP协议如果domain就是ip那么可以直接获取ip，如果是域名则通过DNS服务换得IP。

如果URL中没有指定端口，则使用默认端口**80**。

## 7 HTTP协议版本

仍在使用的HTTP协议有一下几个版本：

- HTTP/0.9：1991年的原型版本，有很多严重的设计缺陷。不支持MIME类型、各种首部、版本号，只支持GET方法，设计的初衷是获取简单的HTTP对象。
- HTTP/1.0：第一个广泛使用的版本。添加了版本号、首部、MIME类型和一些额外方法的支持。
- HTTP/1.0+：各流行的Web服务器和客户端在HTTP协议上添加各种特性，这些特性并未称为官方的事实标准，这种非正式的 HTTP 扩展版本通常 称为 HTTP/1.0+。
- HTTP/1.1：校正 HTTP 设计中的结构性缺陷，明确语义，引入重要 的性能优化措施，并删除一些不好的特性。当前广泛使用的版本。
- HTTP/2.0（HTTP-NG）：是 HTTP/1.1 后继结构的原型建议，它重点关注的是性能的大幅优化， 以及更强大的服务逻辑远程执行框架。

## 8 各种Web组件

- 代理
- 缓存
- 网关
- 隧道
- Agent代理