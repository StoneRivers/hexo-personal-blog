---
title: Mysql启动方式总结
date: 2016-09-21 21:10:22
---
# 1.背景
对于macOS系统，mysql官网提供了以下两种方式：

* 通过dmg包安装。
* 采用 Compressed TAR Archive 解压方式安装。

对于后者，安装后该如何启动，各种启动方式有何区别，通常会困扰刚接触mysql的用户。本文将针对几种常用的启动方式进行介绍对比。
# 2.环境

本文基于mysql 5.7.18进行介绍，具体的安装路径为/usr/local/mysql。  
tar包解压后目录结构如下mysql安装目录的结构如下:

``` shell
➜  pwd
/usr/local/mysql

➜  tree -L 1
.
├── COPYING
├── README
├── bin
├── data
├── docs
├── etc
├── include
├── lib
├── man
├── share
└── support-files

9 directories, 2 files
```
我们将会用到的几个文件如下：
脚本:  

* /usr/local/mysql/bin/mysqld
* /usr/local/mysql/bin/mysqld_safe
* /usr/local/mysql/support-files/mysql.server  

配置文件:

* /usr/local/mysql/etc/my.cnf

#3.mysqld

#4.mysqld_safe
#5.mysql.server


