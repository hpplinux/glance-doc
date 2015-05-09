..
      Copyright 2012 OpenStack Foundation
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

数据库管理
=========

Glance的默认元数据驱动使用了sqlalchemy，这意味着它存在一个必须管理的后端数据库。 ``glance-manage`` 工具提供了一组命令让管理更加容易。

这些命令应该作为 'db' 的子命令来执行：


    glance-manage db <cmd> <args>


同步数据库
--------

    glance-manage db sync <version> <current_version>

如果需要，通过迁移（Migration）控制和升级，创建一个数据库来放置数据库。


确定数据库版本
------------

    glance-manage db version

这回打印Glance数据库当前的迁移级别（Level）。


Upgrading an Existing Database
------------------------------

    glance-manage db upgrade <VERSION>

这会将已经存在的数据库升级到指定的版本。


Downgrading an Existing Database
--------------------------------

    glance-manage db downgrade <VERSION>

这会让已经存在的数据库从当前版本降级到指定的版本。
