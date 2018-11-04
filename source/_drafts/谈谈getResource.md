---
title: 谈谈getResource
date: 2018-04-24 09:34:27
tags: java ClassLoader resource
---
# 1.背景
java提供了如下一些方法从类路径(Class Path)中获取资源文件：  
首先是Class类的相关方法的：
1. `URL getResource(String name);`
2. `InputStream getResourceAsStream(String name)`
 

然后是ClassLoader类相关的方法：
1. `URL getResource(String name);`
2. `Enumeration<URL> getResources(String name)`
3. `InputStream getResourceAsStream(String name)`

# 2.给方法分个类
## 2.1 `getResourceAsStream`做了什么
查看ClassLoader的源码：
``` java
public InputStream getResourceAsStream(String name) {
    URL url = getResource(name);
    try {
        return url != null ? url.openStream() : null;
    } catch (IOException e) {
        return null;
    }
}
```
可以看到 `getResourceAsStream()`和`getResource().openStream()`基本是等价的。
所以我们研究 `getResource()就好。
## 2.2 Class和ClassLoader区别
查看`class.getResource()`的源码如下：
``` java
public java.net.URL getResource(String name) {
    name = resolveName(name);
    ClassLoader cl = getClassLoader0();
    if (cl==null) {
        // A system class.
        return ClassLoader.getSystemResource(name);
    }
    return cl.getResource(name);
}
```
即`class.getResource()` = `classLoader.getResource()`+`class.resolveName()`


