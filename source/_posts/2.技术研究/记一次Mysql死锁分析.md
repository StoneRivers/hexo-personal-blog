---
title: 记一次Mysql死锁分析
date: 2020-07-05 16:34:12
tags:
 - Mysql
 - 死锁
categories:
 - 技术研究
link_title: mysql-deadlock-analyze 
---
# 记一次Mysql死锁分析

## 场景

数据表结构如下：

```sql
CREATE TABLE `doc_transfer` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `source_type` int(11) NOT NULL,
  `source_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `owner_type` int(11) NOT NULL,
  `owner_id` bigint(20) NOT NULL,
  `doc_id` bigint(20) NOT NULL,
  `cts` datetime NOT NULL,
  `uts` datetime NOT NULL,
  PRIMARY KEY (`id`), 
  UNIQUE KEY `source` (`source_type`,`source_id`)) 
ENGINE=InnoDB 
AUTO_INCREMENT=107
DEFAULT CHARSET=utf8mb4 
COLLATE=utf8mb4_unicode_ci;
```
<!-- more -->
其中有两个索引：

1. 唯一键自增索引id。
2. 联合唯一索引 (source_type,source_id)。

当并发使用insert on duplicate key update 插入数据时候会必现死锁。具体的sql如下(其中source_id的值不同)：

```sql
insert into doc_transfer (source_type,  source_id, owner_type,  owner_id, doc_id, cts,  uts) values (0,  '38', 1,  1, 111, '2018-04-16 11:54:24.652',  '2018-04-16 11:54:24.652') ON DUPLICATE KEY UPDATE owner_type=1,owner_id=1, doc_id=111,uts='2018-04-16 11:54:24.652';
```

出现死锁后使用show engine innodb status;查看死锁日志如下：

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/32TJN7YSQFPRBWWC3YFI.png)

大致的信息：

1. transaction1尝试获取一个insert intension lock等待。
2. transaction2持有一个gap lock，等待一个insert intension lock。
3. 最后transaction1回滚。

## 复现

尝试复现这个死锁，步骤如下：
transaction1: 

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/WW72NHFAERJRWUPKG0OL.png)

transaction2: 

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/WXTIYJOW8VQRSG2B9I8N.jpg)

| No   | transaction1 | transaction2   |
| :--- | :----------- | :------------- |
| 1    | begin        |                |
| 2    |              | begin          |
| 3    | sql1         |                |
| 4    |              | sql2（block）  |
| 5    | sql3         |                |
| 6    |              | DeadLock Error |
| 7    | commit       |                |
| 8    |              | commit         |

 ## 分析

在执行完4还未执行5之后看看两个transaction持有和等待锁的情况: 

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/15VM2G5M3T49PYAIQU7A.png)

案例中的Transaction和复现步骤中的Transaction中对应关系如下：

1. Transaction9036：Transaction2
2. Transaction9034：Transaction1

### 锁的持有及等待锁情况：

#### **Transaction1**执行完sql1后

##### 持有:

- IX锁(表锁)
- gap X锁, uniq index在50之前的锁
- record X锁，uniq index在41上的锁
- gap X锁, uniq index在41之前的锁

##### 等待: 无

#### **Transaction2**执行完sql2后 

##### 持有:

- IX锁(表锁)
- gap X锁, uniq index在41之前的锁

##### 等待:

- insert intention lock(40)等待Transaction1的gap X锁(41之前)

#### **Transaction1**执行sql3 

##### 等待:

- insert intention lock(38)等待Transaction1的gap X锁(41之前)

### 图示

### ![](https://stonerivers.oss-cn-beijing.aliyuncs.com/XGVQF35M3C55JPBC2QAN.png)