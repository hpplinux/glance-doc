..
      Copyright 2015 OpenStack Foundation
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

========
基本的架构
========

OpenStack Glance是客户端/服务端架构，它通过给服务端处理的请求向用户提供REST API。

内部的服务器操作通过Glance域名控制器（Domain Controller）分层控制。每一层实线它自己的任务。

所有的文件操作都是使用glace_store库执行的，它负责与外部的后端存储或本地文件系统交互，并且提供统一的访问接口。

Glance uses an sql-based central database (Glance DB) that is shared
with all the components in the system.

.. figure:: /images/architecture.png
   :figwidth: 100%
   :align: center
   :alt: OpenStack Glance Architecture

.. centered:: Image 1. OpenStack Glance Architecture

Glance架构包含几个组件：

* **客户端** - any application that uses Glance server.

* **REST API** - exposes Glance functionality via REST.

* **Database Abstraction Layer (DAL)** - an application programming interface
  which unifies the communication between Glance and databases.

* **Glance Domain Controller** - middleware that implements the main
  Glance functionalities: authorization, notifications, policies,
  database connections.

* **Glance Store** - organizes interactions between Glance and various
  data stores.

* **Registry Layer** - optional layer organizing secure communication between
  the domain and the DAL by using a separate service.
