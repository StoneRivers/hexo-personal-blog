---
title: 常用UML图简介
date: 2020-05-02 01:14:22
tags: 
 - 软件设计
categories: 
 - 工具积累
link_title: uml-diagram
---
## 一、什么是UML

UML 是统一建模语言（UnifiedModelingLanguage）的简称。是面向对象软件的标准化建模语言。

UML1.0 & 2.0 共有14种类型的图：

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/OUN31UIW4X7YGS932H5C.jpg)

本文选择较为常用的四种进行介绍：

1. 类图。
2. 用例图。
3. 状态图。
4. 时序图。

<!-- more -->

## 二、类图

用于表示类、接口、实例等之间相互的静态关系的图。常用于系统设计阶段。

### 2.1 表示一个类

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/WHR3HAMKHN2U9U5SB1H3.jpg)

### 2.2 表示一个接口

在名称上使用<<interface>>标识

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/X9OLCRVBYN0B8NEAFJ4I.jpg)

### 2.3 表示类或者接口之间的关系

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/77RAL1FT05HWNKS9Y9B4.jpg)

## 三、用例图

用例图主要应用于系统需求分析阶段，从用户角度描述系统的需求功能，方便与客户交流，保证需求的唯一性。

### 3.1 参与者

用小人图标表示，是与系统主体交互的外部实体的类元。

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/CKBTKG5JV6VNCY380NP4.jpg)

### 3.2 用例

用例用带描述的椭圆表示，是一个内聚的的功能单元。

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/3TBM7GQ8MPAUNJ2YGVI1.jpg)

### 3.3 用例与参与者的关系

多对多的关系，箭头由用例的参与者指向用例。

### 3.4 用例之间的关系 - 泛化&依赖

- 泛化：用例的泛化关系将特化的用例与一般化的用例联系起来。
- 依赖：一个用例（基用例）可以包含其他用例（包含用例）具有的行为。

## 四、时序图

显示按时间顺序排列的对象之间交互的图。

时序图中包括的建模元素主要有：

1. 角色（Actor）
2. 对象(Object) 
3. 生命线（Lifeline）
4. 控制焦点(Activation)
5. 消息(Message)

主要元素如下图所示：

![](https://stonerivers.oss-cn-beijing.aliyuncs.com/6O0VF3IVHEV06II5AKA6.jpg)

其中messae1为同步消息，message2为返回消息，message3位异步消息，message4为自关联消息。



## 五、状态图

### 5.1 状态

用圆角矩形表示，指在对象的生命周期中的某个条件或者状况。

### 5.2 初态和终态

初态用实心圆点表示，终态用圆形内嵌圆点表示。

### 5.3 转移

转移是两个状态之间的一种关系，表示对象将在源状态（Source State）中执行一定的动作，并在某个特定事件发生而且某个特定的警界条件满足时进入目标状态（Target State）    