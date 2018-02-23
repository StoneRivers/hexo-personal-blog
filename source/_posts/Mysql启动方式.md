---
title: Mysql启动方式总结
tags: mysql
---
# 1.背景
mysql安装后，有多种启动方式，各有优缺点，现进行总结。  

mysql版本为 5.7.18，采用 Compressed TAR Archive 解压方式安装，安装路径为/usr/local/mysql。  

解压后目录结构如下mysql安装目录的结构如下:

``` shell
➜  mysql pwd
/usr/local/mysql
➜  mysql tree -L 1
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

