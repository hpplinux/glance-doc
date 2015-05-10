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

Keystone认证
============

Glance可以选择与Keystone集成。因为Keystone发行版包含了必要的中间件，要配置这个是相对直接的（Straightforward）。一旦你已经安装了Keystone和修改过配置文件，新创建的镜像将会有认证用户的租户的 `owner` 属性，还有这些镜像访问权限的 `is_public` 属性，如果是 `false` 就限制了只有拥有者、管理员和镜像分享分享过的用户或租户有权限访问。

配置Glance服务器来使用Keystone
---------------------------

Keystone是通过使用中间件和Glance集成的。Glance API和Glance Registry的默认配置文件使用名为 ``unauthenticated-context`` 的中间件，它会生成包含空认证信息的请求上下文。为了配置Glance使用Keystone，``authtoken`` 和 ``context`` 中间件必须部署和取代 ``unauthenticated-context`` 中间件。 ``authtoken`` 中间件执行认证令牌的检查和获得真实用户的认证信息。这可以在Keystone发布版中找到。

配置Glance API来使用Keystone
--------------------------

配置Glance API来使用Keystone是相对直接的。第一步是确保这两个中间件在 ``glance-api-paste.ini`` 已经申明。这里是 ``authtoken`` 的一个例子::

  [filter:authtoken]
  paste.filter_factory = keystonemiddleware.auth_token:filter_factory
  identity_uri = http://127.0.0.1:35357
  admin_user = glance_admin
  admin_tenant_name = service_admins
  admin_password = password1234

这些变量的实际值需要根据你的情况来设置。对于更多信息，请参考Keystone的 ``auth_token`` 中间件文档。这里简单介绍一下：

* The ``identity_uri`` variable points to the Keystone Admin service.
  This information is used by the middleware to actually query Keystone about
  the validity of the authentication tokens.
   ``identity_uri`` 变量之处Keystone管理员服务。这个信息会被中间件使用来查询Keystone关于认证令牌的检查。
* The admin auth credentials (``admin_user``, ``admin_tenant_name``,
  ``admin_password``) will be used to retrieve an admin token. That
  token will be used to authorize user tokens behind the scenes.
  管理员认证信息（``admin_user``、``admin_tenant_name``和``admin_password``）是被用于获得管理员令牌。这个令牌会用于场景后认证用户令牌。

最后，要真正使用Keystone认证，应用流水线必须修改。它默认是这样的::

  [pipeline:glance-api]
  pipeline = versionnegotiation unauthenticated-context apiv1app

你的定制的流水线依赖于其他选项，例如镜像缓存。这里必须用 ``authtoken`` 和 ``context`` 来替换 ``unauthenticated-context`` ::

  [pipeline:glance-api]
  pipeline = versionnegotiation authtoken context apiv1app

配置Glance Registry来使用Keystone
-------------------------------------------

配置Glance Registry来使用Keystone也是相对直接的。需要添加和Glance API相同的中间件到 ``glance-registry-paste.ini`` ；可以参考上面 ``authtoken`` 的例子。

同样，要开启Keystone认证，必须选择合适的应用流水线。它默认是这样的::

  [pipeline:glance-registry-keystone]
  pipeline = authtoken context registryapp

要开启上面的应用流水线，在你的 ``glance-registry.conf`` 配置文件需要在添加 ``paste_deploy`` 组添加 ``flavor`` 属性来选择合适的部署方案（Flavor）。

  [paste_deploy]
  flavor = keystone

.. 注意::
  如果你的认证服务使用非 ``管理员``要识别管理员级别的权限，你必须在 ``glance-registry.conf`` 和 ``glance-api.conf`` 中的 ``admin_role`` 配置选中定义它。
