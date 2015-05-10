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

策略
====

Glance的公共API通过一个策略文件让部分用户才能调用。这个文档解释了策略是如何配置的和它们应用在那些方面。

策略是由一组规则组成，这些规则可以由授权的租户通过 "Brain" 策略执行。

构建策略的配置文件
---------------

策略的配置文件时一个简单的JSON对象，它包含了一组规则。每个顶级（Top-level）键是规则的名字。每个规则是一个字符串，它描述了在Glance API中可以执行的行为（Action）。
、
拥有规则的行为包括以下这些：

* ``get_images`` - 列举可见的镜像实体（Entity）

  * ``GET /v1/images``
  * ``GET /v1/images/detail``
  * ``GET /v2/images``

* ``get_image`` - 获得特定的镜像实体

  * ``HEAD /v1/images/<IMAGE_ID>``
  * ``GET /v1/images/<IMAGE_ID>``
  * ``GET /v2/images/<IMAGE_ID>``

* ``download_image`` - 下载二进制镜像数据

  * ``GET /v1/images/<IMAGE_ID>``
  * ``GET /v2/images/<IMAGE_ID>/file``

* ``upload_image`` - 上传二进制镜像数据

  * ``POST /v1/images``
  * ``PUT /v1/images/<IMAGE_ID>``
  * ``PUT /v2/images/<IMAGE_ID>/file``

* ``copy_from`` - 从URL拷贝二进制镜像数据

  * ``POST /v1/images``
  * ``PUT /v1/images/<IMAGE_ID>``

* ``add_image`` - 创建镜像实体

  * ``POST /v1/images``
  * ``POST /v2/images``

* ``modify_image`` - 更新镜像实体

  * ``PUT /v1/images/<IMAGE_ID>``
  * ``PUT /v2/images/<IMAGE_ID>``

* ``publicize_image`` - 创建或上传带属性的镜像

  * ``POST /v1/images`` 其中属性 ``is_public`` = ``true``
  * ``PUT /v1/images/<IMAGE_ID>`` 其中属性 ``is_public`` = ``true``
  * ``POST /v2/images`` 其中属性 ``visibility`` = ``public``
  * ``PUT /v2/images/<IMAGE_ID>`` 其中属性 ``visibility`` = ``public``

* ``delete_image`` - 删除镜像实体和相关的二进制数据

  * ``DELETE /v1/images/<IMAGE_ID>``
  * ``DELETE /v2/images/<IMAGE_ID>``

* ``add_member`` - 为镜像的成员仓库（Repo）添加成员关系

  * ``POST /v2/images/<IMAGE_ID>/members``

* ``get_members`` - 列举几个捏茶能的成员

  * ``GET /v1/images/<IMAGE_ID>/members``
  * ``GET /v2/images/<IMAGE_ID>/members``

* ``delete_member`` - 删除镜像的成员关系

  * ``DELETE /v1/images/<IMAGE_ID>/members/<MEMBER_ID>``
  * ``DELETE /v2/images/<IMAGE_ID>/members/<MEMBER_ID>``

* ``modify_member`` - 创建或更新镜像的成员关系

  * ``PUT /v1/images/<IMAGE_ID>/members/<MEMBER_ID>``
  * ``PUT /v1/images/<IMAGE_ID>/members``
  * ``POST /v2/images/<IMAGE_ID>/members``
  * ``PUT /v2/images/<IMAGE_ID>/members/<MEMBER_ID>``

* ``manage_image_cache`` - 允许使用镜像缓存管理API


为了限制某个角色或者一组角色的行为，你可以像这样列举角色 ::

  {
    "delete_image": ["role:admin", "role:superuser"]
  }

上面可以添加规则只允许拥有"admin"或者"superuser"角色的用户才能删除镜像。

写规则
-----

角色检查可以像它以前那样继续工作。如果检查中定义的角色是它拥有的用户，那检查就会通过，例如 ``role:admin`` 。

要写一个普遍的规则，你需要知道Glance提供的三个值，它们在规则中的冒号(``:``)左边使用。当前用户认证的那些值是下面的格式：

- role
- tenant
- owner

冒号左边可以包含Python理解的任意值，例如：

- ``True``
- ``False``
- ``"a string"``
- &c.

使用 ``tenant`` 和 ``owner`` 只在镜像藏獒功能有用。可以考虑下面的格式::

    tenant:%(owner)s

这将会使用当前认证用户的 ``tenant`` 的值。它也会用正在使用（Acting upon）的镜像的 ``owner`` 值。如果这两个值都相等那么检查就会通过。镜像中所有属性（也就是镜像额外的属性）可以使用冒号右边的值。以下就是最有用的：

- ``owner``
- ``protected``
- ``is_public``

所以，你可以像下面这样构建一系列规则::

    {
        "not_protected": "False:%(protected)s",
        "is_owner": "tenant:%(owner)s",
        "is_owner_or_admin": "rule:is_owner or role:admin",
        "not_protected_and_is_owner": "rule:not_protected and rule:is_owner",

        "get_image": "rule:is_owner_or_admin",
        "delete_image": "rule:not_protected_and_is_owner",
        "add_member": "rule:not_protected_and_is_owner"
    }

实例
----

例子1。（默认的策略配置）

 ::

  {
      "default": ""
  }

注意这里空的JSON列表意味着任何人都可以调用所有Glance API的方法。

例子2。不允许非管理员的修改调用。

 ::

  {
      "default": "",
      "add_image": "role:admin",
      "modify_image": "role:admin",
      "delete_image": "role:admin"
  }
