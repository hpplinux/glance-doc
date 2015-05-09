..
      Copyright 2013 OpenStack Foundation
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

常见镜像属性
==========

当添加镜像到Glance时，你可以指定一些常见的镜像数据，这对使用你镜像的客户有好处。

这个文档解释了这些属性名和它们预期的值。

常见的镜像属性是用JSON格式（Schema）来描述的，在Glance源代码的etc/schema-image.json中可以找到。

**architecture**
----------------

操作系统架构在这里指定
http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html

**instance_uuid**
-----------------

用于创建这个镜像的实例的ID。

**kernel_id**
-------------

保存在Glance的镜像ID，当启动一个类似AWS镜像时它应该当做内核来使用。

**ramdisk_id**
--------------

保存在Glance的镜像ID，当启动一个类似AWS镜像时它应该当做Ramdisk来使用。

**os_distro**
-------------

常见的操作系统分发版名字在这里定义
http://docs.openstack.org/trunk/openstack-compute/admin/content/adding-images.html

**os_version**
--------------

由发布者（Distributor）指定的操作系统版本。
