..
      Copyright 2011 OpenStack Foundation
      All Rights Reserved.

      Licensed under the Apache License, Version 2.0 (the "License"); you may
      not use this file except in compliance with the License. You may obtain
      a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
      WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
      License for the specific language governing permissions and limitations
      under the License.

磁盘和容器格式
============

当添加镜像到Glance时，你必须指定虚拟机镜像的 *磁盘格式* 和 *容器格式* 。磁盘和容器格式每次部署时都可以配置的。这个文档为了公布 *磁盘格式* 和 *容器格式* 的值的全局预定。

磁盘格式
-------

虚拟机镜像的磁盘格式就是底层的磁盘镜像格式。虚拟设备供应商有不同的制定虚拟机磁盘镜像信息的格式。

你可以将你的镜像磁盘格式设置为以下任意一种：

* **raw**

  这是非结构化磁盘镜像格式

* **vhd**

  这是VHD磁盘格式，它是一种由VMWare、Xen、微软、VirtualBox和其他虚拟机提供商（Monitor）采用的常见磁盘格式

* **vmdk**

  这是另一个由很多通用虚拟机提供商支持的常见磁盘格式

* **vdi**

  这是由VirtualBox虚拟机提供商和QEMU模拟器支持的磁盘格式

* **iso**

  这是一种光学磁盘（例如CDROM）的数据内容的打包格式

* **qcow2**

  这是由QEMU模拟器支持并且能够支持动态拓展和支持写时复制（Copy on Write）的磁盘格式

* **aki**

  这表明保存在Glance的是Amazon内核（Kernel）镜像

* **ari**

  这表明保存在Glance的是Amazon Ramdisk镜像

* **ami**

  这表明保存在Glance的是Amazon机器（Machine）镜像

容器格式
-------

容器格式是指虚拟机镜像用的是哪一种文件格式，这文件格式同样包含了关于具体虚拟机的元数据。

注意容器格式字符串目前并不在Glance和其他OpenStack组件中使用，所以如果你不确定容器格式，简单地使用 **bare** 也是安全的。

你可以设置你镜像的容器格式为以下任意一种：

* **bare**

  这表明没有此镜像的容器或元数据封装（Envelope）

* **ovf**

  这是OVF容器格式

* **aki**

  这表明保存在Glance的是Amazon内核镜像

* **ari**

  这表明保存在Glance的是Amazon Ramdisk镜像

* **ami**

  表明存储在Glance的是Amazon机器（Machine）镜像

* **ova**

  表明存储在Glance的是OVA压缩文件