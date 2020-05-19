---
title: java unsafe
date: 2020-05-18 10:21:57
tags:
categories:
---
## 1.总览
Unsafe是位于sun.misc包下的一个类，主要提供一些用于执行低级别、不安全操作的方法，如直接访问系统内存资源、自主管理内存资源等，这些方法在提升Java运行效率、增强Java语言底层资源操作能力方面起到了很大的作用。
<!-- more -->
## 2.具体介绍
### 2.1 内存操作
#### 2.1.1 内存分配
 - `long allocateMemory(long bytes)`
 - `long reallocateMemory(long address, long bytes)` 重新分配内存。
 - `void freeMemory(long address)`

#### 2.1.2 内存存取
 - `void putType(long address, T data)` 
 - `T getType(long address)`  
	其中T可以是：boolean、byte、char、short、int、long、float、double、Object。

#### 2.1.3 操作对象字段值
 - `void putType(Object o, long offset, T data)` 
 - `T getType(Object o, long offset)`  
	和2.1.1中的方法对比，这套方法的内存地址定位不是直接使用address，而是使用Object+Field offset的方式。
	
	于此对应还有一套结合了volatile语义的方法，来保证可见性。
 - `void putTypeVolatile(Object o, long offset, T data)` 
 - `T getTypeVolatile(Object o, long offset)`  

#### 2.1.4 存取指针
 - `long getAddress(long var1)`
 - `void putAddress(long var1, long var3)`  对一个给定的内存地址获取或设置一个本地指针

### 2.2 CAS
 - `boolean compareAndSwapObject(Object o, long offset,  Object expected, Object update)`
 - `boolean compareAndSwapInt(Object o, long offset, int expected,int update)`
 - `boolean compareAndSwapLong(Object o, long offset, long expected, long update)`

### 2.3 线程调度
 - `void unpark(Object thread)`
 - `void park(boolean isAbsolute, long time)`  park & unpark 在底层依赖的是每个java线程关联的park结构（由虚拟机维护）来实现。
 - `void monitorEnter(Object o)`
 - `void monitorExit(Object o)`
 - `boolean tryMonitorEnter(Object o)`
这三个方法已标记为`@Deprecated`,操作的是java中每个对象关联的对象锁（monitor），Synchronize关键字就是依赖的这个monitor。

### 2.4 内存屏障
 - `void loadFence()`禁止load操作重排序。屏障前的store操作不能被重排序到屏障后，屏障后的store操作不能被重排序到屏障前
 - `void storeFence()`禁止store操作重排序。屏障前的store操作不能被重排序到屏障后，屏障后的store操作不能被重排序到屏障前
 - `void storeFence()`禁止load和store操作重排序

### 2.5 系统
 - `int addressSize()`
 - `int pageSize()`
 - `int getLoadAverage(double[] loadavg, int nelems)`

 
### 2.6 待总结：

    public native void setMemory(Object var1, long var2, long var4, byte var6);

    public native void copyMemory(Object var1, long var2, Object var4, long var5, long var7);


    public native long staticFieldOffset(Field var1);

    public native long objectFieldOffset(Field var1);

    public native Object staticFieldBase(Field var1);

    public native boolean shouldBeInitialized(Class<?> var1);

    public native void ensureClassInitialized(Class<?> var1);

    public native int arrayBaseOffset(Class<?> var1);

    public native int arrayIndexScale(Class<?> var1);



    public native Class<?> defineClass(String var1, byte[] var2, int var3, int var4, ClassLoader var5, ProtectionDomain var6);

    public native Class<?> defineAnonymousClass(Class<?> var1, byte[] var2, Object[] var3);

    public native Object allocateInstance(Class<?> var1) throws InstantiationException;

    public native void throwException(Throwable var1);


    public native void putOrderedObject(Object var1, long var2, Object var4);

    public native void putOrderedInt(Object var1, long var2, int var4);

    public native void putOrderedLong(Object var1, long var2, long var4);

