---
title: HTTP权威指南读书笔记 (2) - URL与资源
date: 2020-09-08 09:54:01
tags:
 - 网络协议
 - 读书笔记
categories:
 - 理论学习
link_title: url-resource
---
## 1.资源标识符

URI（Uniform Resource  Identifier）是更通用的资源标识符，有两个子集：URL和URI。URI并非是HTTP协议独有的，很多协议都使用URI作为协议的资源标识方式：

- mailto:president@whitehouse.gov
- ftp://ftp.lots-o-books.com/pub/complete-price-list.xls

虽说HTTP协议选择URI作为资源标识方式。但实际上，HTTP 应用程序处理的只是其子集URL。

<!-- more -->

## 2.URL语法

URL通用格式：

`<scheme>://<user>:<password>@<host>:<port>/<path>;<params>?<query>#<frag>`

一共有九个部分：

- 方案：用于告诉解析处理URL的应用程序使用什么协议。
- 用户、密码：有的服务器需要输入用户名和密码才允许访问。
- 主机：主机名或者IP，用来定位访问的服务器。
- 端口：指定服务器正在监听的网络端口，HTTP协议默认的端口号为80。
- 路径：用于在服务器内部定位资源。
- 参数、查询：能够自定义传递一些信息。
- 片段：用于在一个大的资源中定位某个部分。

最重要的三个部分：scheme、host、path。



## 3.相对URL

## 4.URL转义

为什么URL中不能出现一些字符，需要进行转移。因为网络标准[RFC 1738](http://www.ietf.org/rfc/rfc1738.txt)做了硬性规定：

> "...Only alphanumerics [0-9a-zA-Z], the special characters "$-_.+!*'()," [not including the quotes - ed], and reserved characters used for their reserved purposes may be used unencoded within a URL."
>
> "只有字母和数字[0-9a-zA-Z]、一些特殊符号"$-_.+!*'(),"[不包括双引号]、以及某些保留字，才可以不经过编码直接用于URL。"

## 5.未来展望URN

URL虽然当前工作的还不错，但还是有一些缺陷的，一旦某个资源被移走了，URL就不再有效了（301、302能解决部分问题）。

URN（uniform resource name）就是想解决这个问题的：资源一旦有了准确名称，不论其位于何处都可以找到这个对象。

但由于URL工作的还算OK，大家也都比较熟悉，同时URN的推广工作量巨大。所以URL虽然有一些限制，但使用URN进行替代并不是Web开发社区所面临的最紧迫的问题。
