---
title: 写给小星星的Mysql教程 - 第一讲
date: 2019-02-21 23:31:22
tags: 
 - Mysql 
 - 小星星
categories: 学习总结
---
# 一、Mysql简介
## 1.1 如何理解DB(数据库)
数据库(DB，database)是按照数据结构来组织、存储和管理数据的“仓库”。  
知道它能存放数据就好。  
Mysql就是常用的关系型数据库之一，开源不要钱！！
<!-- more -->
## 1.2 如何与DB交流
市面上那么多数据库，如果每种数据库开发厂商都各自制定使用者操作数据库的语言规范，那么开发人员只有死。  
ANSI（American National Standards Institute 美国国家标准化组织）制定了一套访问数据库的标准，其常用的主要命令几乎所有的数据库厂商都予以了支持。这种标准化语言就叫SQL（Structured Query Language）。
# 二、搭建学习环境
## 2.1 搭建数据库
要学习Mysql我们需要搭建一套Mysql服务，可以选择在本地搭建或者远程服务器上搭建，小星星可以不关心这里，小张已经在服务器上搭建了一套Mysql服务，直接用就好。  
具体的信息如下：  
Host（数据库服务器域名）:`stonerivers.me`  
UserName（数据库用户名）:`maya`  
Password（）:`******`  
不懂就过，一会用的上这些信息。
## 2.2 链接数据库
### 2.2.1 Mysql GUI
推荐使用 [Sequel Pro](https://sequelpro.com/) 来更直观边界的链接数据库。
> Sequel Pro is a fast, easy-to-use Mac database management application for working with MySQL databases.  

### 2.2.1 Terminal
需要先安装MySQL Community Server，然后用命令行进行链接。黑不溜秋的，难看的要死！！

## 2.3 使用Sequel Pro
安装完成Sequel Pro打开后，新填加一个链接如下图，并保存（便于下次直接登录）
![](1.jpg)
将2.1中数据库相应信息填入后Connect就能连上数据库啦！！
![](2.jpg)

## 2.4 查询数据
### 2.4.1 通过界面操作
![](3.jpg)
试试各种查询条件，比如id = 1。
### 2.4.2 通过SQL查询
![](4.jpg)
示例Sql为：`select * from test_table where id = 2`
### 2.4.3 命令行操作展示
上面整个操作流程如果用命令行进行操作：
![](5.jpg)