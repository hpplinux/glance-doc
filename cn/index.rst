..
      Copyright 2010 OpenStack Foundation
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

欢迎阅读Glance文档！
=================

Glance项目提供了服务让用户可以上传和发现用于其他服务的数据资源。这目前包括镜像和元数据定义（Metadata Definition）。

Glance镜像服务包括了发现、注册和获得虚拟机镜像。Glance提供的RESTful API允许查询虚拟机镜像元数据和获取实际的镜像。

虚拟机镜像通过Glance可以保存在各种地方，从简单的文件系统到OpenStack Swift这样的对象存储系统。

Glance和所有OpenStack项目一样，是遵循以下设计指引来实现的：

* **给予组件的架构**: 能快速添加新的行为
* **高可用性**: 能在重（serious）负载中拓展
* **容忍错误**: 独立的进程间避免关联（cascading）的错误
* **可恢复性**: 错误能够容易地诊断、Debug和纠正
* **开发的标准**: 按照社区驱动的API来实现

这个文档是由Sphinx工具生成并保留在源码树中。更多的Glance文档和其他OpenStack组件可以在这找到`OpenStack wiki`_.

.. _`OpenStack wiki`: http://wiki.openstack.org

Glance背景概念
=============

.. toctree::
   :maxdepth: 1

   architecture
   database_architecture
   identifiers
   statuses
   formats
   common-image-properties
   metadefs-concepts

安装/配置Glance
==============

.. toctree::
   :maxdepth: 1

   installing
   configuring
   authentication
   policies

Glance运维
=========

.. toctree::
   :maxdepth: 1

   controllingservers
   db
   cache
   notifications

使用Glance
==========

.. toctree::
   :maxdepth: 1

   glanceapi
   glanceclient
   glancemetadefcatalogapi
