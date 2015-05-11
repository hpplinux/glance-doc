..
      Copyright (c) 2014 Hewlett-Packard Development Company, L.P.


      Licensed under the Apache License, Version 2.0 (the "License");
      you may not use this file except in compliance with the License.
      You may obtain a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied. 
      See the License for the specific language governing permissions and
      limitations under the License.

使用Glance元数据定义目录公共API
===========================

Glance服务提供通用的API给供应商、管理员、服务和用户来定义可用的键值对和标签（Tag）元数据。目标是为OpenStack用户支持更好的跨域（Artifact）、服务和项目的元数据协作（Collaboration）。

这是关于可用元数据的定义，这能用于不同类型的资源（镜像、Artifacts、卷、Flavors、Aggregates等等）。一种定义包含了属性类型、它的键、它的描述和它的约束（Constraint）。这个目录（Catalog）不会存储特定实例属性的值。

举个例子，对虚拟CPU拓扑属性的核数的定义包含了可以使用的键、一种描述和值的约束，例如要求它必须是整数。所以，一个有可能通过Horizon使用的用户能够搜索这个目录列出所有可用的值，然后加到Flavor或镜像内。他们可以在列表内见到虚拟CPU拓扑属性并且知道它必须是整数，它的键和值将保存在拥有这资源的服务中（Nova是Flavor而Glance是镜像）。

Diagram: https://wiki.openstack.org/w/images/b/bb/Glance-Metadata-API.png

Glance元数据定义目录实现是从v2版本的API开始。

认证
----

Glance依赖于Keystone和OpenStack认证API来处理客户端的认证。你必须从Keystone获得认证令牌并通过 ``X-Auth-Token`` 头发送所有API请求给Glance。Glance会与Keystone通信验证令牌的有效性和获得认证信息（Credential）。

参考 :doc:`authentication` for more information on integrating with Keystone.

使用v2.X
--------

为了举例，我们假设Glance API服务器运行在 ``http://glance.example.com`` 和默认端口为80。

列举可用的命名空间（Namespace）
**************************

我们想列举授权用户可以访问的命名空间列表。这包括了用户拥有的命名空间、其他用户分享的命名空间和公共的命名空间。

我们发送 ``GET`` 请求到 ``http://glance.example.com/v2/metadefs/namespaces`` 来请求这些可用命名空间的列表。返回的数据是以下格式的JSON编码映射::

  {
    "namespaces": [
        {
            "namespace": "MyNamespace",
            "display_name": "My User Friendly Namespace",
            "description": "My description",
            "visibility": "public",
            "protected": true,
            "owner": "The Test Owner",
            "self": "/v2/metadefs/namespaces/MyNamespace",
            "schema": "/v2/schemas/metadefs/namespace",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z",
            "resource_type_associations": [
                {
                    "name": "OS::Nova::Aggregate",
                    "created_at": "2014-08-28T17:13:06Z",
                    "updated_at": "2014-08-28T17:13:06Z"
                },
                {
                    "name": "OS::Nova::Flavor",
                    "prefix": "aggregate_instance_extra_specs:",
                    "created_at": "2014-08-28T17:13:06Z",
                    "updated_at": "2014-08-28T17:13:06Z"
                }
            ]
        }
    ],
    "first": "/v2/metadefs/namespaces?sort_key=created_at&sort_dir=asc",
    "schema": "/v2/schemas/metadefs/namespaces"
  }


.. 注意::
   列举命名空间只显示每个命名空间的概要信息，包括总数和资源类型相关信息。详细的响应包含了它所有的对象定义、属性定义等等可以通过独立的GET命名空间请求来获得。

过滤命名空间列表
**************

``GET /v2/metadefs/namespaces`` 请求接受请求参数来过滤返回的命名空间列表。下面列举这些查询参数的详细信息。

* ``resource_types=RESOURCE_TYPES``

  Filters namespaces having a ``resource_types`` within the list of
  comma separated ``RESOURCE_TYPES``.

GET resource also accepts additional query parameters:

* ``sort_key=KEY``

  Results will be ordered by the specified sort attribute ``KEY``. Accepted
  values include ``namespace``, ``created_at`` (default) and ``updated_at``.

* ``sort_dir=DIR``

  Results will be sorted in the direction ``DIR``. Accepted values are ``asc``
  for ascending or ``desc`` (default) for descending.

* ``marker=NAMESPACE``

  A namespace identifier marker may be specified. When present only
  namespaces which occur after the identifier ``NAMESPACE`` will be listed,
  i.e. the namespaces which have a `sort_key` later than that of the marker
  ``NAMESPACE`` in the `sort_dir` direction.

* ``limit=LIMIT``

  When present the maximum number of results returned will not exceed ``LIMIT``.

.. 注意::

  If the specified ``LIMIT`` exceeds the operator defined limit (api_limit_max)
  then the number of results returned may be less than ``LIMIT``.

* ``visibility=PUBLIC``

  An admin user may use the `visibility` parameter to control which results are
  returned (PRIVATE or PUBLIC).


获得Namespace
*************

我们想列举授权用户可以访问的命名空间的更详细信息。这包括了属性、对象和资源类型的相关信息（Association）。

我们发送 ``GET`` 请求到 ``http://glance.example.com/v2/metadefs/namespaces/{namespace}`` 来请求这些可用命名空间的详细信息。返回的数据是以下格式的JSON编码映射::

  {
    "namespace": "MyNamespace",
    "display_name": "My User Friendly Namespace",
    "description": "My description",
    "visibility": "public",
    "protected": true,
    "owner": "The Test Owner",
    "schema": "/v2/schemas/metadefs/namespace",
    "resource_type_associations": [
        {
            "name": "OS::Glance::Image",
            "prefix": "hw_",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z"
        },
        {
            "name": "OS::Cinder::Volume",
            "prefix": "hw_",
            "properties_target": "image",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z"
        },
        {
            "name": "OS::Nova::Flavor",
            "prefix": "filter1:",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z"
        }
    ],
    "properties": {
        "nsprop1": {
            "title": "My namespace property1",
            "description": "More info here",
            "type": "boolean",
            "default": true
        },
        "nsprop2": {
            "title": "My namespace property2",
            "description": "More info here",
            "type": "string",
            "default": "value1"
        }
    },
    "objects": [
        {
            "name": "object1",
            "description": "my-description",
            "self": "/v2/metadefs/namespaces/MyNamespace/objects/object1",
            "schema": "/v2/schemas/metadefs/object",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z",
            "required": [],
            "properties": {
                "prop1": {
                    "title": "My object1 property1",
                    "description": "More info here",
                    "type": "array",
                    "items": {
                        "type": "string"
                    }
                }
            }
        },
        {
            "name": "object2",
            "description": "my-description",
            "self": "/v2/metadefs/namespaces/MyNamespace/objects/object2",
            "schema": "/v2/schemas/metadefs/object",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z",
            "properties": {
                "prop1": {
                    "title": "My object2 property1",
                    "description": "More info here",
                    "type": "integer",
                    "default": 20
                }
            }
        }
    ]
  }

获得可用资源类型
**************

我们想列举Glance中所有可用的资源类型

我们发送 ``GET`` 请求到 ``http://glance.example.com/v2/metadefs/resource_types`` 来获得所有资源类型。

返回的数据是以下格式的JSON编码映射::

  {
    "resource_types": [
        {
            "created_at": "2014-08-28T17:13:04Z",
            "name": "OS::Glance::Image",
            "updated_at": "2014-08-28T17:13:04Z"
        },
        {
            "created_at": "2014-08-28T17:13:04Z",
            "name": "OS::Cinder::Volume",
            "updated_at": "2014-08-28T17:13:04Z"
        },
        {
            "created_at": "2014-08-28T17:13:04Z",
            "name": "OS::Nova::Flavor",
            "updated_at": "2014-08-28T17:13:04Z"
        },
        {
            "created_at": "2014-08-28T17:13:04Z",
            "name": "OS::Nova::Aggregate",
            "updated_at": "2014-08-28T17:13:04Z"
        },
        {
            "created_at": "2014-08-28T17:13:04Z",
            "name": "OS::Nova::Instance",
            "updated_at": "2014-08-28T17:13:04Z"
        }
    ]
  }


获得命名空间相关的资源类型
**********************

我们想列特定命名空间相关的资源类型列表

我们发送 ``GET`` 请求到 ``http://glance.example.com/v2/metadefs/namespaces/{namespace}/resource_types`` 来获得资源类型。

返回的数据是以下格式的JSON编码映射::

  {
    "resource_type_associations" : [
        {
           "name" : "OS::Glance::Image",
           "prefix" : "hw_",
           "created_at": "2014-08-28T17:13:04Z",
           "updated_at": "2014-08-28T17:13:04Z"
        },
        {
           "name" :"OS::Cinder::Volume",
           "prefix" : "hw_",
           "properties_target" : "image",
           "created_at": "2014-08-28T17:13:04Z",
           "updated_at": "2014-08-28T17:13:04Z"
        },
        {
           "name" : "OS::Nova::Flavor",
           "prefix" : "hw:",
           "created_at": "2014-08-28T17:13:04Z",
           "updated_at": "2014-08-28T17:13:04Z"
        }
    ]
  }

添加命名空间
**********

我们想创建包含属性、对象等的新命名空间

我们发送 ``POST`` 请求来添加命名空间到Glance中::

  POST http://glance.example.com/v2/metadefs/namespaces/

输入的JSON编码格式如下::

  {
    "namespace": "MyNamespace",
    "display_name": "My User Friendly Namespace",
    "description": "My description",
    "visibility": "public",
    "protected": true
  }

.. 注意::
   可选的属性、对象和资源类型关联信息可以用同样的输入加进去。看看上面GET命名空间的输出（输入也是类似的）。

更新命名空间
**********

我们想更新已经存在的命名空间

我们发送 ``PUT`` 请求来更新Glance中的命名空间::

  PUT http://glance.example.com/v2/metadefs/namespaces/{namespace}

输入数据和添加命名空间是类似的。

删除命名空间
**********

我们想删除一个存在的命名空间，这包含它所有的对象和属性等等

我们发送 ``DELETE`` 请求来删除Glance中的命名空间::

  DELETE http://glance.example.com/v2/metadefs/namespaces/{namespace}


关联资源类型和命名空间
******************

我们想将资源类型关联到已经存在的命名空间

我们发送 ``POST`` 请求来关联资源类型到Glance中::

  POST http://glance.example.com/v2/metadefs/namespaces/{namespace}/resource_types

输入的JSON编码格式如下::

   {
           "name" :"OS::Cinder::Volume",
           "prefix" : "hw_",
           "properties_target" : "image",
           "created_at": "2014-08-28T17:13:04Z",
           "updated_at": "2014-08-28T17:13:04Z"
   }


移除命名空间关联的资源类型
*********************

我们想解除命名空间和资源类型的关联

我们发送 ``DELETE`` 请求来解除Glance中的命名空间和资源类型::

  DELETE http://glance.example.com/v2//metadefs/namespaces/{namespace}/resource_types/{resource_type}


列举命名空间的对象
***************

我们想列举在制定命名空间下的元数据定义对象的列表

我们发送 ``GET`` 请求到 ``http://glance.example.com/v2/metadefs/namespaces/{namespace}/objects`` 来获取对象。

输入的JSON编码格式如下::

  {
        "objects": [
        {
            "name": "object1",
            "description": "my-description",
            "self": "/v2/metadefs/namespaces/MyNamespace/objects/object1",
            "schema": "/v2/schemas/metadefs/object",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z",
            "required": [],
            "properties": {
                "prop1": {
                    "title": "My object1 property1",
                    "description": "More info here",
                    "type": "array",
                    "items": {
                        "type": "string"
                    }
                }
            }
        },
        {
            "name": "object2",
            "description": "my-description",
            "self": "/v2/metadefs/namespaces/MyNamespace/objects/object2",
            "schema": "/v2/schemas/metadefs/object",
            "created_at": "2014-08-28T17:13:06Z",
            "updated_at": "2014-08-28T17:13:06Z",
            "properties": {
                "prop1": {
                    "title": "My object2 property1",
                    "description": "More info here",
                    "type": "integer",
                    "default": 20
                }
            }
        }
    ],
    "schema": "/v2/schemas/metadefs/objects"
  }

添加对象到命名空间
***************

我们想创建一个对象将属性归组

我们发送 ``POST`` 请求在Glance中将对象添加到命名空间内::

  POST http://glance.example.com/v2/metadefs/namespaces/{namespace}/objects

输入的JSON编码格式如下::

  {
    "name": "StorageQOS",
    "description": "Our available storage QOS.",
    "required": [
        "minIOPS"
    ],
    "properties": {
        "minIOPS": {
            "type": "integer",
            "description": "The minimum IOPs required",
            "default": 100,
            "minimum": 100,
            "maximum": 30000369
        },
        "burstIOPS": {
            "type": "integer",
            "description": "The expected burst IOPs",
            "default": 1000,
            "minimum": 100,
            "maximum": 30000377
        }
    }
  }

更新特定命名空间的对象
******************

我们想要更新已经存在的对象

我们发送 ``PUT`` 请求来更新Glance中的对象::

  PUT http://glance.example.com/v2/metadefs/namespaces/{namespace}/objects/{object_name}

输出数据和添加对象是类似的

删除特定命名空间的对象
******************

我们想删除已经存在的对象

我们发送 ``DELETE`` 请求在Glance中删除命名空间的对象::

  DELETE http://glance.example.com/v2/metadefs/namespaces/{namespace}/objects/{object_name}

添加属性定义到制定命名空间
*********************

我们想要在命名空间创建新的属性定义

我们发送 ``POST`` 请求在Glance中添加属性定义到命名空间::

  POST http://glance.example.com/v2/metadefs/namespaces/{namespace}/properties

输入的JSON编码格式如下::

  {
    "name": "hypervisor_type",
    "title" : "Hypervisor",
    "type": "array",
    "description": "The type of hypervisor required",
    "items": {
        "type": "string",
        "enum": [
            "hyperv",
            "qemu",
            "kvm"
        ]
    }
  }


更新指定命名空间的属性定义
*********************

我们想要更新已经存在的对象

我们发送 ``PUT`` 请求来更新Glance中明明空间的属性定义::

  PUT http://glance.example.com/v2/metadefs/namespaces/{namespace}/properties/{property_name}

输入数据和添加属性定义是类似的

删除指定命名空间的属性定义
**********************

我们想删除已经存在的对象

我们你发送 ``DELETE`` 请求来删除Glance中一个命名空间内的属性定义::

  DELETE http://glance.example.com/v2/metadefs/namespaces/{namespace}/properties/{property_name}


API消息的本地化
-------------
Glance支持HTTP消息的本地化。举个例子，一个HTTP客户端即使服务器本地（Locale）语言是英文也可以接收到中文的API信息。

如何使用它
*********
要获得本地化的API消息，HTTP客户端需要指定 **Accept-Language** 头来申明用什么语言翻译消息。关于Accept-Language更多的内容请参考 http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html

一个典型的API请求是类似下面这样子的::

   curl -i -X GET -H 'Accept-Language: zh' -H 'Content-Type: application/json'
   http://127.0.0.1:9292/v2/metadefs/namespaces/{namespace}

然后响应信息是类似下面这样子的::

   HTTP/1.1 404 Not Found
   Content-Length: 234
   Content-Type: text/html; charset=UTF-8
   X-Openstack-Request-Id: req-54d403a0-064e-4544-8faf-4aeef086f45a
   Date: Sat, 22 Feb 2014 06:26:26 GMT

   <html>
   <head>
   <title>404 Not Found</title>
   </head>
   <body>
   <h1>404 Not Found</h1>
   &#25214;&#19981;&#21040;&#20219;&#20309;&#20855;&#26377;&#26631;&#35782; aaa &#30340;&#26144;&#20687;<br /><br />
   </body>
   </html>

.. 注意::
   请确保目标Glance服务器在/usr/share/locale-langpack/有语言包。
