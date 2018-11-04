---
title: JNA使用简介
date: 2018-11-04 12:57:52
tags:
---
本文介绍如何使用JNA来实现java对静态lib的调用。
# 1.JNA是什么
> JNA provides Java programs easy access to native shared libraries without writing anything but Java code - no JNI or native code is required.   

github地址：[https://github.com/java-native-access/jna](https://github.com/java-native-access/jna)

# 2.如何生成一个动态链接文件（.dylib）
编写一个最简单的add.c文件  

add.c

```
int add(int a, int b)
{
   return a+b;
}
```
`gcc -c add.c -o add.o` 生成目标文件 add.o。
`gcc add.o -dynamiclib -current_version 1.0 -o libAdd.dylib`，生成.dylib文件。
置于这里为什么起名为 libAdd.dylib 而不是 add.dylib 后文会提到。

# 3.如何使用动态链接文件
## 3.1 动态链接文件放哪里
将文件放到java工程的classpath下，具体的路径和系统有关，mac系统下其路径为classpath:darwin/libAdd.dylib。  
其它系统下，具体放哪个文件夹可以具体参考官方文档。

## 3.2 引入JNA
JNA的maven依赖为：  

```
<dependency>
	<groupId>net.java.dev.jna</groupId>
	<artifactId>jna</artifactId>
	<version>${jna.version}</version>
</dependency>
```

## 3.3 代理接口
写一个接口继承 JNA 包中的 Libary（com.sun.jna.Libary） 接口，对 libAdd.dylib 中的方法进行相应的java方法声明即可。

```
public interface AddLibrary extends Library {

	int add(int a,int b);

}
```
除了常见的类型对应为，指针的映射会特殊一些，这里列举一些：   
1. void* --> Pointer   
2. char* --> String  
3. int* --> IntByReference  
4. char** --> PointerByReference

## 3.4 使用代理接口

```
AddLibrary addLibrary = (AddLibrary)Native.load("Add", AddLibrary.class);
Assert.assertEquals(addLibary.add(1, 2), 3);
```



