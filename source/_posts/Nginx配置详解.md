---
title: Nginx配置详解
date: 2018-02-24 13:37:58
tags: Nginx
---
# 一、背景
工作中常遇到需要修改Nginx配置的地方，现总结一些，便于查阅。  
本文采用的nginx版本为openresty/1.11.2.4

```
> ./nginx -v
nginx version: openresty/1.11.2.4
```

# 二、总览
查看nginx安装后的默认配置文件如下（./conf/nginx.conf）:

```shell
//context:main

user  nobody;

events {

    //context:events
    worker_connections  1024;
    
}


http {

    //context:http
    
    server {
    
        //context:server
        listen 80;
        
        location / {
        
            ·//context:location
        
        }
    }
}
```
这里只摘取了配置文件的骨架，下几个小结会详细介绍，这里根据配置的所在位置将配置文件分为一下几个context（在上面的示例中用//标记）。


* 主配置，main。
* 链接处理，events。
* http服务器，http，server，location。

配置文件还有一些其它的context，由于不常用这里就不进行展开了。

# 三、具体配置
## 1 主要配置
### 1.1 nginx worker进程运行的用户及用户组
e.g `user userName groupName;`
context: `main`  
默认值为 nobody，nobody。如果没有指定组，则组名与用户名一致。
### 1.2 nginx 进程数
e.g `worker_processes 8;`
context: `main`  
建议与cpu核数保持一致。
### 1.3 nginx 日志配置
e.g `error_log /var/log/nginx/info.log info;`
context: `main`  
如上配置会把info级别的日志写到/var/log/nginx/info.log中。  
具体的日志级别有从低到高有如下6个级别：

* debug
* info
* notice
* warn
* error
* crit

如果不进行相关配置，日志会写到默认的目录下。如果想彻底关闭日志，可以这样配置`error_log  /dev/null;`

### 1.4 pid 存储文件配置

e.g `pid logs/nginx.pid;`
context: `main`  

将nginx的process_id存储在NGINX_BASE/logs/nginx.pid。

### 1.5 单进程最大文件描述符打开数量
e.g `worker_rlimit_nofile 4096;`
context: `main`  
建议与 `ulimit -n`保持一致。  
Q: worker_rlimit_nofile 设置的是单进程最大文件描述符打开数量，那为何不是`ulimit -n`数量除以worker_processes呢？  
A: 由于nginx的线程负载通常不太均匀。

## 2 连接处理相关
### 2.1 I/O模型
e.g：`use epoll;`
context: `events`  

通常有如下选择：

* select、poll 标准模型。
* Kqueue：FreeBSD 4.1+、OpenBSD 2.9+、NetBSD 2.0、MacOS系统下的高效模型。
* epoll：Linux 2.6+系统下的高效模型。
* /dev/poll：Solaris 7 11/99、HP/UX 11.22+ (eventport)、IRIX 6.5.15+、Tru64 UNIX 5.1A+系统下的高效模型。


###2.2 工作进程最大链接数
e.g：`worker_connections 65535;`
context: `events`  
单个线程能处理的最大链接数目。

##3 http服务器
### 3.1 MimeTypes对应关系   
e.g

```shell
types {
    application/octet-stream bin exe dll;
    application/octet-stream deb;
    application/octet-stream dmg;
}
```

通常会将这种对应方式定义在单独的mime.types文件中，然后通过include引入到conf中。  
e.g

```shell
include mime.types;
```
下面是mime.types文件的一段结节：

```shell
types {
    text/html                             html htm shtml;
    text/css                              css;
    text/xml                              xml;
    image/gif                             gif;
    image/jpeg                            jpeg jpg;
    application/javascript                js;
    application/atom+xml                  atom;
    application/rss+xml                   rss;
    ......
}
```
当web服务器收到静态的资源文件请求时，依据该配置根据文件的后缀名找到对应的MIME Type，设置HTTP Response的Content-Type，进行返回。  
`default_type application/octet-stream;`  

当在配置的MIME Type列表中找不到相应后缀时，使用的类型。

以上两个配置项目的 context: `http`、`server`、`location`

### 3.3 ServerNamesHashTable配置
`server_names_hash_bucket_size 32|64|128；`
`server_names_hash_max_size 512；`  
context: `http`  
nginx使用一个HashTable来存储存储server_names便于快速查找，这里就是对这个hash_table进行配置。关于ServerNameHashTable的作用，详见[官方文档](http://nginx.org/en/docs/hash.html)。  

### 3.4 RequestHeaderBuffer配置
`client_header_buffer_size 4k;`
`large_client_header_buffers 8 128k;`  
context: `http`、`server`  
nginx以client_header_buffer_size定义的缓存区来存储请求头，当大小超过client_header_buffer_size定义的大小时，就会以large_client_header_buffers定义的大小来进行存储。
### 3.5 静态资源缓存
[111](https://www.centos.bz/2016/10/using-nginx-caching-static-content/)
### 3.6 请求体相关配置
e.g `client_max_body_size 300m;`
context: `http`、`server`、`location`  
请求体最大大小限制。  
e.g `client_body_buffer_size 512k;`
context: `http`、`server`、`location`  
请求体缓冲区大小，超过这个大小会被写到文件中。
### 3.7 I/O优化相关
e.g `sendfile on;`
context: `http`、`server`、`location`  
用于控制linux系统是否调用sendfile函数（zero copy 方式）来输出文件。
建议所有应用设为on。如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络IO处理速度，降低系统uptime。  

e.g `tcp_nopush on;`
context: `http`、`server`、`location`  
只有在sendfile为on的时候才生效，用于开启在FreeBSD上开启TCP_NOPUSH socket或者在Linux上开启TCP_CORK socket。

### 3.8 与代理服务器连接相关
e.g `proxy_connect_timeout 90;`
context: `http`、`server`、`location`  
与后端代理服务器连接超时时间，即发起握手请求后等待响应的超时时间。  
e.g `proxy_read_timeout 180;`
context: `http`、`server`、`location` 
从后端代理服务器两次连续的数据读取之间的间隔超时时间。  
e.g `proxy_send_timeout 180;`
context: `http`、`server`、`location` 
nginx想后端代理服务器连续两次写数据的间隔超时时间。
### 3.9 对请求内容的控制
e.g `proxy_set_body "body"`
context: `http`、`server`、`location`
设置请求体。  
e.g `	proxy_set_header Host $proxy_host;`
context: `http`、`server`、`location` 
设置请求头。

### 3.10 upstream配置
upstream主要是用来配置一组ip:port组合及其访问顺序。主要的访问顺序有如下几种。
1.轮训:

```
upstream bakend {
    server 127.0.0.1:8080;
    server 127.0.0.1:8081;
    server 127.0.0.1:8082;
}
```
2.加权轮训:

```
upstream bakend {
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=10;
    server 127.0.0.1:8082 weight=20;
}
```
3.ip hash

```
upstream bakend {
    ip_hash;
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=10;
    server 127.0.0.1:8082 weight=20;
}
```
根据客户端的ip进行分配，能保证同一个客户端的请求能打到同一台服务器。  
4.根据响应时间分配

```
upstream bakend {
    fair;
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=10;
    server 127.0.0.1:8082 weight=20;
}
```
按后端服务器的响应时间来分配请求，响应时间短的优先分配。  
5.url_hash

```
upstream bakend {
    hash $request_uri;
    hash_method crc32;
    server 127.0.0.1:8080 weight=5;
    server 127.0.0.1:8081 weight=10;
    server 127.0.0.1:8082 weight=20;
}
```
按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存时比较有效。
### 3.11 虚拟机配置
```shell
server {
    listen 80;
    server_name name;
    location ~ ^/path1/path2 {
    }
}
```
主要配置项是监听端口，server名字和location。location的配置在下面章节单独整理
## 4 location配置  
### 4.1 location的path匹配规则
通用格式：`location [=|~|~*|^~] /uri/ { … }`

| 模式 | 含义 |
| --- | --- |
| `location = /uri` | 精确匹配，只有完全匹配上才能生效|
| `location ^~ /uri` | 对URL路径进行前缀匹配，并且在正则之前|
| `location ~ pattern` | 区分大小写的正则匹配|
| `location ~* pattern` | 不区分大小写的正则匹配|
| `location /uri` | 不带任何修饰符，也表示前缀匹配，但是在正则匹配之后|

匹配顺序:

* 精确匹配 `=`
* 屏蔽正则的前缀匹配 `^~`，优先使用匹配长度更长的。
* 正则匹配 `~``~*`（按文件中出现的顺序）
* 普通前缀匹配   

### 4.2 关于proxy_pass是否含path
如果proxy_pass不仅含protocal，domain还含path，则location中的path会被忽略。
如果proxy_pass只含protocal，domain，则location中的path不会被忽略，会被一起拼接。
e.g 
配置A：

```shell
location ~ ^/subpath {
    proxy_pass http://127.0.0.1:8080/;
}
```
配置B：

```shell
location ~ ^/subpath {
    proxy_pass http://127.0.0.1:8080;
}
```
访问路径：`http://stonerivers.me/subpath/index.html`
配置A会打到：`http://127.0.0.1/index.html`
配置B会打到：`http://127.0.0.1/subpath/index.html`
## 5 rewrite配置相关
### 5.1 基本配置
e.g

```
rewrite /path/subpath/(.*)$ /$1 break;
```
其中$1代表regex中匹配上的第一组。
### 5.2 关于break和last
last：停止处理后续rewrite指令集，然后对当前重写的新URI从头开始在rewrite指令集上重新查找。
break：停止处理后续rewrite指令集，不在重新查找，其后的非rewrite指令可以继续执行。

## 6 访问日志
### 6.1 日志格式配置
e.g

```
log_format  main  '$remote_addr - $remote_user "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';
```
context: `http`  
定义一个名为main的日志格式，具体的日志内容通常由一些列nginx的内建变量组成。关于nginx的内建变量可以参考这篇博客。  
### 6.2 日志配置
e.g 

```shell
access_log  logs/access.log  main;
```
context: `http`,`server`,`location`  
如上配置将日志以main定义的格式存储在logs/access.log文件中。

# 四、参考
[nginx配置一（全局配置）](http://lobert.iteye.com/blog/1929280)
[nginx中的MIME.types的作用](http://blog.csdn.net/Debug_zhang/article/details/50749646)
[（总结）Nginx配置文件nginx.conf中文详解](http://www.ha97.com/5194.html)
[Nginx配置文件（nginx.conf）配置详解](http://blog.csdn.net/tjcyjd/article/details/50695922)
[最新版 nginx内置变量 大全](http://www.cnphp.info/nginx-embedded-variables-lasted-version.html)
[Zero Copy 简介](http://blog.csdn.net/mango_song/article/details/44451439)


