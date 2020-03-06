---
title: 写给小星星的Mysql教程 - 第二讲
date: 2019-03-14 14:31:22
tags: 
 - Mysql 
 - 小星星
categories: 学习总结
---
# 一、数据的导入导出
这样的方式在生产环境中并不常见,但是在学习数据库时能通过这样直接的方式传递数据,便于学习交流。
## 1.1 导出数据到.sql文件
操作方式如下{% asset_img 1.jpg %}
<!-- more -->
导出的文件使用文本编辑打开内容如下:![](2.jpg)
可以看到其中的内容就是一系列sql命令，依据这些命令能重建之前的数据表。
## 1.2 从.sql文件导入数据
### step1，删除原表（可以略过）
为了演示导入，先将原来表删除。可以执行 sql `DROP TABLE table1`。或者使用如下方式：
![](3.jpg)
### step2 导入数据，选择导出的sql文件进行import
![](4.jpg)

# 二、认识mysql的存储结构
## 2.1 表列（column）
每张数据表都有其特定的结构，称为列（column）。即每张表存什么数据是确定的。
![](5.jpg)

上面这张表有4列：  

列序 | 列名 | 含义
:----: | :----: | :---:
1 | id | 行id
2 |  name | 姓名
3 |  cid | 公司id
4 |  enrty_time | 入职时间

## 2.2 表行（row）
mysql数据库中数据是以行为单位进行存储的，每条数据对应一行。

# 三、单表简单查询
通过上一节知道了mysql数据库存储数据有两个维度（row & column），然后一个库中有多个表，那么mysql的查询大致可以理解为从这三个维度去筛选数据。这里先介绍单表查询，即数据从一张表中获取，不涉及多张表数据的合并。
## 3.1 单表查询所有行所有列
sql：
```
SELECT * FROM table1
```

其结果如下：
![](6.jpg)

sql中的 `*` 表示查询所有列，同时sql中没有限制条件，所以会查询所有行。

## 3.2 单表查询所有行指定列
sql：
```
SELECT column1Name,column2Name... FROM table1
```

其中columnName为需要指定的列名。例如`SELECT name,entry_time FROM table1`查询结果如下：
![](7.jpg)

## 3.3 限制查询行数
### 3.3.1 查询前n行
上面两种查询的结果都是全表的数据，如果只想看数据的前n行可以使用`LIMIT`关键字。
sql：`SELECT * FROM table1 LIMIT n` 查询前n行。例如`SELECT * FROM table1 LIMIT 3`查询结果如下：
![](8.jpg)
需要注意到，这种方式只能过滤出默认**排序规则**下的前n行。如何使用其他排序规则之后会介绍。
### 3.3.2 跳过前m行，再查询n行
如果不希望从第一行开始查询n行，而是希望跳过一定的行，可以使用`OFFSET`关键字。
sql：`SELECT * FROM table1 LIMIT n OFFSET m` 。例如`SELECT * FROM table1 LIMIT 3 OFFSET 2`查询结果如下：
![](9.jpg)

# 四、对查询结果排序
不使用排序的时候，查询出的数据均使用的是默认的排序策略（即数据的插入顺序）。如果需要以自己期望的顺序查询数据可以使用 `ORDER BY` 关键字。
## 4.1 按单列排序
sql：`SELECT * FROM table ORDER BY column1Name`。查询所有的数据行，并按column1排序，排序方式为正序（俗称从小到大）。如果遇到两行数据相同则按其插入顺序排列。
例如 `SELECT * FROM table1 ORDER BY cid`的结果如下：
![](10.jpg)
## 4.2 按单列倒序排序
倒序排序在columnName后加DESC关键字即表示按某一列倒序排序。  
例如 `SELECT * FROM table1 ORDER BY cid DESC`的结果如下：
![](11.jpg)
## 4.3 按多列综合排序
sql：`SELECT * FROM table ORDER BY column1Name,column2Name,column3Name...`。查询所有的数据行，并按column1排序，排序方式为正序（俗称从小到大）。如果遇到两行数据相同则按column2正序排序，如果遇到column2也相同则按column3正序排序，以此类推。同样，column后面也可以跟DESC关键字，表示这一列的排序规则为倒序。
例如 `SELECT * FROM table1 ORDER BY cid DESC,id`的结果如下（为了方便演示，将id为12的数据的cid改为了5）：
![](12.jpg)

# 五、附件
本节sql文件：[点击下载](chapter2.sql)

