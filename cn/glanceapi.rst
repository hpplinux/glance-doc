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

使用Glance镜像公共API
===================

Glance完全实现了OpenStack镜像API的1.0、1.1和2.0版本。镜像API定义（Specification）是随着Glance开发的，但这并不是Glance项目的一部分。

认证
----

Glance依赖Keystone和OpenStack认证API来处理客户端的认证。你必须从Keystone获得认证令牌（Token）并通过 ``X-Auth-Token`` 头来发送所有Glance API请求。Glance会与Keystone通信来认证令牌并获得你的认证签名（Credential）。

阅读 :doc:`authentication` 获得更多与Keystone集成的信息。

使用v1.X
--------

为了举例，假设有个Glance API服务器运行在地址 ``http://glance.example.com`` 并且默认端口是80.

列举可用的镜像
************

我们想要列举一个授权用户能够访问的可用镜像列表。这包括了用户拥有的镜像、其他用户分享的镜像和公共的镜像。

我们发送 ``GET`` 请求到 ``http://glance.example.com/v1/images`` 来请求这些可用镜像的列表。返回的数据是以下格式的JSON编码映射::

  {'images': [
    {'uri': 'http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9',
     'name': 'Ubuntu 10.04 Plain',
     'disk_format': 'vhd',
     'container_format': 'ovf',
     'size': '5368709120'}
    ...]}


详细得列举可用的镜像
*****************

我们想要列举一个授权用户能够访问更详细的可用镜像列表。这包括了用户拥有的镜像、其他用户分享的镜像和公共的镜像。

我们发送 ``GET`` 请求到 ``http://glance.example.com/v1/images/detail`` 来请求这些可用镜像的列表。返回的数据是以下格式的JSON编码映射::

  {'images': [
    {'uri': 'http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9',
     'name': 'Ubuntu 10.04 Plain 5GB',
     'disk_format': 'vhd',
     'container_format': 'ovf',
     'size': '5368709120',
     'checksum': 'c2e5db72bd7fd153f53ede5da5a06de3',
     'created_at': '2010-02-03 09:34:01',
     'updated_at': '2010-02-03 09:34:01',
     'deleted_at': '',
     'status': 'active',
     'is_public': true,
     'min_ram': 256,
     'min_disk': 5,
     'owner': null,
     'properties': {'distro': 'Ubuntu 10.04 LTS'}},
    ...]}

.. 注意::

  所有返回的时间错都是UTC时间

   `updated_at` 时间戳是镜像元数据上次更新的时间戳，不是它的镜像数据更新时间，因为所有镜像数据一旦保存在Glance就是不可变的了

   `properties` 字段是自由格式的键值对，保存了镜像的元数据

   `checksum` 字段是镜像文件数据的MD5校验和（Checksum）

   `is_public` 字段是一个布尔值，表明镜像是不是共用的

   `min_ram` 字段是一个整数，声明运行这个镜像所需的最小内存，单位是M（Megabyte）

   `min_disk` 字段是一个整数，声明在实例中运行这个镜像所需要的最小磁盘空间，单位是（Gigabyte）

   `owner` 字段是一个字符串，它要么是空要么就申明了这个镜像的拥有者

过滤镜像列表
**********

 ``GET /v1/images`` 和 ``GET /v1/images/detail`` 请求都可用接受查询参数来过滤返回的镜像列表。下面的列表详细介绍这些请求参数。

* ``name=NAME``

  过滤拥有能够匹配 ``NAME`` 的 ``name`` 属性的镜像。

* ``container_format=FORMAT``

  过滤拥有能够匹配 ``FORMAT`` 的 ``container_format`` 属性的镜像。

  更详细的信息可参考 :doc:`About Disk and Container Formats <formats>`

* ``disk_format=FORMAT``

  过滤拥有能够匹配 ``FORMAT`` 的 ``disk_format`` 属性的镜像。

  更详细的信息可参考 :doc:`About Disk and Container Formats <formats>`

* ``status=STATUS``

  Filters images having a ``status`` attribute matching ``STATUS``

  更详细的信息可参考 :doc:`About Image Statuses <statuses>`

* ``size_min=BYTES``

  Filters images having a ``size`` attribute greater than or equal to ``BYTES``

* ``size_max=BYTES``

  Filters images having a ``size`` attribute less than or equal to ``BYTES``

These two resources also accept additional query parameters:

* ``sort_key=KEY``

  Results will be ordered by the specified image attribute ``KEY``. Accepted
  values include ``id``, ``name``, ``status``, ``disk_format``,
  ``container_format``, ``size``, ``created_at`` (default) and ``updated_at``.

* ``sort_dir=DIR``

  Results will be sorted in the direction ``DIR``. Accepted values are ``asc``
  for ascending or ``desc`` (default) for descending.

* ``marker=ID``

  An image identifier marker may be specified. When present only images which
  occur after the identifier ``ID`` will be listed, i.e. the images which have
  a `sort_key` later than that of the marker ``ID`` in the `sort_dir` direction.

* ``limit=LIMIT``

  When present the maximum number of results returned will not exceed ``LIMIT``.

.. 注意::

  If the specified ``LIMIT`` exceeds the operator defined limit (api_limit_max)
  then the number of results returned may be less than ``LIMIT``.

* ``is_public=PUBLIC``

  An admin user may use the `is_public` parameter to control which results are
  returned.

  When the `is_public` parameter is absent or set to `True` the following images
  will be listed: Images whose `is_public` field is `True`, owned images and
  shared images.

  When the `is_public` parameter is set to `False` the following images will be
  listed: Images (owned, shared, or non-owned) whose `is_public` field is `False`.

  When the `is_public` parameter is set to `None` all images will be listed
  irrespective of owner, shared status or the `is_public` field.

.. 注意::

  Use of the `is_public` parameter is restricted to admin users. For all other
  users it will be ignored.

获得镜像元数据Retrieve Image Metadata
***********************

We want to see detailed information for a specific virtual machine image
that the Glance server knows about.
todo
我们想列举授权用户可以访问的命名空间的更详细信息。这包括了属性、对象和资源类型的相关信息（Association）。

我们发送 ``GET`` 请求到 ``http://glance.example.com/v2/metadefs/namespaces/{namespace}`` 来请求这些可用命名空间的详细信息。返回的数据是以下格式的JSON编码映射::

We have queried the Glance server for a list of images and the
data returned includes the `uri` field for each available image. This
`uri` field value contains the exact location needed to get the metadata
for a specific image.

Continuing the example from above, in order to get metadata about the
first image returned, we can issue a ``HEAD`` request to the Glance
server for the image's URI.

We issue a ``HEAD`` request to
``http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9`` to
retrieve complete metadata for that image. The metadata is returned as a
set of HTTP headers that begin with the prefix ``x-image-meta-``. The
following shows an example of the HTTP headers returned from the above
``HEAD`` request::

  x-image-meta-uri              http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9
  x-image-meta-name             Ubuntu 10.04 Plain 5GB
  x-image-meta-disk_format      vhd
  x-image-meta-container_format ovf
  x-image-meta-size             5368709120
  x-image-meta-checksum         c2e5db72bd7fd153f53ede5da5a06de3
  x-image-meta-created_at       2010-02-03 09:34:01
  x-image-meta-updated_at       2010-02-03 09:34:01
  x-image-meta-deleted_at
  x-image-meta-status           available
  x-image-meta-is_public        true
  x-image-meta-min_ram          256
  x-image-meta-min_disk         0
  x-image-meta-owner            null
  x-image-meta-property-distro  Ubuntu 10.04 LTS

.. 注意::

  All timestamps returned are in UTC

  The `x-image-meta-updated_at` timestamp is the timestamp when an
  image's metadata was last updated, not its image data, as all
  image data is immutable once stored in Glance

  There may be multiple headers that begin with the prefix
  `x-image-meta-property-`.  These headers are free-form key/value pairs
  that have been saved with the image metadata. The key is the string
  after `x-image-meta-property-` and the value is the value of the header

  The response's `ETag` header will always be equal to the
  `x-image-meta-checksum` value

  The response's `x-image-meta-is_public` value is a boolean indicating
  whether the image is publicly available

  The response's `x-image-meta-owner` value is a string which may either
  be null or which will indicate the owner of the image


获得镜像原始数据Retrieve Raw Image Data
***********************

We want to retrieve that actual raw data for a specific virtual machine image
that the Glance server knows about.

We have queried the Glance server for a list of images and the
data returned includes the `uri` field for each available image. This
`uri` field value contains the exact location needed to get the metadata
for a specific image.

Continuing the example from above, in order to get metadata about the
first image returned, we can issue a ``HEAD`` request to the Glance
server for the image's URI.

We issue a ``GET`` request to
``http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9`` to
retrieve metadata for that image as well as the image itself encoded
into the response body.

The metadata is returned as a set of HTTP headers that begin with the
prefix ``x-image-meta-``. The following shows an example of the HTTP headers
returned from the above ``GET`` request::

  x-image-meta-uri              http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9
  x-image-meta-name             Ubuntu 10.04 Plain 5GB
  x-image-meta-disk_format      vhd
  x-image-meta-container_format ovf
  x-image-meta-size             5368709120
  x-image-meta-checksum         c2e5db72bd7fd153f53ede5da5a06de3
  x-image-meta-created_at       2010-02-03 09:34:01
  x-image-meta-updated_at       2010-02-03 09:34:01
  x-image-meta-deleted_at
  x-image-meta-status           available
  x-image-meta-is_public        true
  x-image-meta-min_ram          256
  x-image-meta-min_disk         5
  x-image-meta-owner            null
  x-image-meta-property-distro  Ubuntu 10.04 LTS

.. 注意::

  All timestamps returned are in UTC

  The `x-image-meta-updated_at` timestamp is the timestamp when an
  image's metadata was last updated, not its image data, as all
  image data is immutable once stored in Glance

  There may be multiple headers that begin with the prefix
  `x-image-meta-property-`.  These headers are free-form key/value pairs
  that have been saved with the image metadata. The key is the string
  after `x-image-meta-property-` and the value is the value of the header

  The response's `Content-Length` header shall be equal to the value of
  the `x-image-meta-size` header

  The response's `ETag` header will always be equal to the
  `x-image-meta-checksum` value

  The response's `x-image-meta-is_public` value is a boolean indicating
  whether the image is publicly available

  The response's `x-image-meta-owner` value is a string which may either
  be null or which will indicate the owner of the image

  The image data itself will be the body of the HTTP response returned
  from the request, which will have content-type of
  `application/octet-stream`.


添加新的镜像Add a New Image
***************

We have created a new virtual machine image in some way (created a
"golden image" or snapshotted/backed up an existing image) and we
wish to do two things:

 * Store the disk image data in Glance
 * Store metadata about this image in Glance

We can do the above two activities in a single call to the Glance API.
Assuming, like in the examples above, that a Glance API server is running
at ``glance.example.com``, we issue a ``POST`` request to add an image to
Glance::

  POST http://glance.example.com/v1/images

The metadata about the image is sent to Glance in HTTP headers. The body
of the HTTP request to the Glance API will be the MIME-encoded disk
image data.


保留新的镜像Reserve a New Image
*******************

We can also perform the activities described in `Add a New Image`_ using two
separate calls to the Image API; the first to register the image metadata, and
the second to add the image disk data.  This is known as "reserving" an image.

The first call should be a ``POST`` to ``http://glance.example.com/v1/images``,
which will result in a new image id being registered with a status of
``queued``::

  {"image":
   {"status": "queued",
    "id": "71c675ab-d94f-49cd-a114-e12490b328d9",
    ...}
   ...}

The image data can then be added using a ``PUT`` to
``http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9``.
The image status will then be set to ``active`` by Glance.


**镜像元数据的HTTP头Image Metadata in HTTP Headers**

Glance will view as image metadata any HTTP header that it receives in a
``POST`` request where the header key is prefixed with the strings
``x-image-meta-`` and ``x-image-meta-property-``.

The list of metadata headers that Glance accepts are listed below.

* ``x-image-meta-name``

  This header is required, unless reserving an image. Its value should be the
  name of the image.

  Note that the name of an image *is not unique to a Glance node*. It
  would be an unrealistic expectation of users to know all the unique
  names of all other user's images.

* ``x-image-meta-id``

  This header is optional.

  When present, Glance will use the supplied identifier for the image.
  If the identifier already exists in that Glance node, then a
  **409 Conflict** will be returned by Glance. The value of the header
  must be an uuid in hexadecimal string notation
  (i.e. 71c675ab-d94f-49cd-a114-e12490b328d9).

  When this header is *not* present, Glance will generate an identifier
  for the image and return this identifier in the response (see below)

* ``x-image-meta-store``

  This header is optional. Valid values are one of ``file``, ``s3``, ``rbd``,
  ``swift``, ``cinder``, ``gridfs``, ``sheepdog`` or ``vsphere``

  When present, Glance will attempt to store the disk image data in the
  backing store indicated by the value of the header. If the Glance node
  does not support the backing store, Glance will return a **400 Bad Request**.

  When not present, Glance will store the disk image data in the backing
  store that is marked default. See the configuration option ``default_store``
  for more information.

* ``x-image-meta-disk_format``

  This header is required, unless reserving an image. Valid values are one of
  ``aki``, ``ari``, ``ami``, ``raw``, ``iso``, ``vhd``, ``vdi``, ``qcow2``, or
  ``vmdk``.

  For more information, see :doc:`About Disk and Container Formats <formats>`

* ``x-image-meta-container_format``

  This header is required, unless reserving an image. Valid values are one of
  ``aki``, ``ari``, ``ami``, ``bare``, or ``ovf``.

  For more information, see :doc:`About Disk and Container Formats <formats>`

* ``x-image-meta-size``

  This header is optional.

  When present, Glance assumes that the expected size of the request body
  will be the value of this header. If the length in bytes of the request
  body *does not match* the value of this header, Glance will return a
  **400 Bad Request**.

  When not present, Glance will calculate the image's size based on the size
  of the request body.

* ``x-image-meta-checksum``

  This header is optional. When present it shall be the expected **MD5**
  checksum of the image file data.

  When present, Glance will verify the checksum generated from the backend
  store when storing your image against this value and return a
  **400 Bad Request** if the values do not match.

* ``x-image-meta-is_public``

  This header is optional.

  When Glance finds the string "true" (case-insensitive), the image is marked as
  a public image, meaning that any user may view its metadata and may read
  the disk image from Glance.

  When not present, the image is assumed to be *not public* and owned by
  a user.

* ``x-image-meta-min_ram``

  This header is optional. When present it shall be the expected minimum ram
  required in megabytes to run this image on a server.

  When not present, the image is assumed to have a minimum ram requirement of 0.

* ``x-image-meta-min_disk``

  This header is optional. When present it shall be the expected minimum disk
  space required in gigabytes to run this image on a server.

  When not present, the image is assumed to have a minimum disk space requirement of 0.

* ``x-image-meta-owner``

  This header is optional and only meaningful for admins.

  Glance normally sets the owner of an image to be the tenant or user
  (depending on the "owner_is_tenant" configuration option) of the
  authenticated user issuing the request.  However, if the authenticated user
  has the Admin role, this default may be overridden by setting this header to
  null or to a string identifying the owner of the image.

* ``x-image-meta-property-*``

  When Glance receives any HTTP header whose key begins with the string prefix
  ``x-image-meta-property-``, Glance adds the key and value to a set of custom,
  free-form image properties stored with the image.  The key is the
  lower-cased string following the prefix ``x-image-meta-property-`` with dashes
  and punctuation replaced with underscores.

  For example, if the following HTTP header were sent::

    x-image-meta-property-distro  Ubuntu 10.10

  Then a key/value pair of "distro"/"Ubuntu 10.10" will be stored with the
  image in Glance.

  There is no limit on the number of free-form key/value attributes that can
  be attached to the image.  However, keep in mind that the 8K limit on the
  size of all HTTP headers sent in a request will effectively limit the number
  of image properties.


Update an Image
***************

Glance will view as image metadata any HTTP header that it receives in a
``PUT`` request where the header key is prefixed with the strings
``x-image-meta-`` and ``x-image-meta-property-``.

If an image was previously reserved, and thus is in the ``queued`` state, then
image data can be added by including it as the request body.  If the image
already as data associated with it (e.g. not in the ``queued`` state), then
including a request body will result in a **409 Conflict** exception.

On success, the ``PUT`` request will return the image metadata encoded as HTTP
headers.

See more about image statuses here: :doc:`Image Statuses <statuses>`


列举镜像成员关系（Membership）List Image Memberships
**********************

We want to see a list of the other system tenants (or users, if
"owner_is_tenant" is False) that may access a given virtual machine image that
the Glance server knows about.  We take the `uri` field of the image data,
append ``/members`` to it, and issue a ``GET`` request on the resulting URL.

Continuing from the example above, in order to get the memberships for the
first image returned, we can issue a ``GET`` request to the Glance
server for
``http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9/members``
.  What we will get back is JSON data such as the following::

  {'members': [
   {'member_id': 'tenant1',
    'can_share': false}
   ...]}

The `member_id` field identifies a tenant with which the image is shared.  If
that tenant is authorized to further share the image, the `can_share` field is
`true`.


列举共享的镜像List Shared Images
******************

We want to see a list of images which are shared with a given tenant.  We issue
a ``GET`` request to ``http://glance.example.com/v1/shared-images/tenant1``.  We
will get back JSON data such as the following::

  {'shared_images': [
   {'image_id': '71c675ab-d94f-49cd-a114-e12490b328d9',
    'can_share': false}
   ...]}

The `image_id` field identifies an image shared with the tenant named by
*member_id*.  If the tenant is authorized to further share the image, the
`can_share` field is `true`.


添加镜像成员Add a Member to an Image
************************

We want to authorize a tenant to access a private image.  We issue a ``PUT``
request to
``http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9/members/tenant1``
.  With no body, this will add the membership to the image, leaving existing
memberships unmodified and defaulting new memberships to have `can_share`
set to `false`. We may also optionally attach a body of the following form::

  {'member':
   {'can_share': true}
  }

If such a body is provided, both existing and new memberships will have
`can_share` set to the provided value (either `true` or `false`).  This query
will return a 204 ("No Content") status code.


从镜像中移除成员Remove a Member from an Image
*****************************

We want to revoke a tenant's right to access a private image.  We issue a
``DELETE`` request to ``http://glance.example.com/v1/images/1/members/tenant1``.
This query will return a 204 ("No Content") status code.


代替镜像的成员关系列表Replace a Membership List for an Image
**************************************

The full membership list for a given image may be replaced.  We issue a ``PUT``
request to
``http://glance.example.com/v1/images/71c675ab-d94f-49cd-a114-e12490b328d9/members``
with a body of the following form::

  {'memberships': [
   {'member_id': 'tenant1',
    'can_share': false}
   ...]}

All existing memberships which are not named in the replacement body are
removed, and those which are named have their `can_share` settings changed as
specified.  (The `can_share` setting may be omitted, which will cause that
setting to remain unchanged in the existing memberships.)  All new memberships
will be created, with `can_share` defaulting to `false` if it is not specified.


在2.0版本镜像成员的修改Image Membership Changes in Version 2.0
---------------------------------------

Version 2.0 of the Images API eliminates the ``can_share`` attribute of image
membership.  In the version 2.0 model, image sharing is not transitive.

In version 2.0, image members have a ``status`` attribute that reflects how the
image should be treated with respect to that image member's image list.

* The ``status`` attribute may have one of three values: ``pending``,
  ``accepted``, or ``rejected``.

* By default, only those shared images with status ``accepted`` are included in
  an image member's image-list.

* Only an image member may change his/her own membership status.

* Only an image owner may create members on an image.  The status of a newly
  created image member is ``pending``.  The image owner cannot change the
  status of a member.


1.x API调用的区别Distinctions from Version 1.x API Calls
***************************************

* The response to a request to list the members of an image has changed.

  call: ``GET`` on ``/v2/images/{imageId}/members``

  response: see the JSON schema at ``/v2/schemas/members``

* The request body in the call to create an image member has changed.

  call: ``POST`` to ``/v2/images/{imageId}/members``

  request body::

  { "member": "<MEMBER_ID>" }

  where the {memberId} is the tenant ID of the image member.

  The member status of a newly created image member is ``pending``.

新API调用New API Calls
*************

* Change the status of an image member

  call: ``PUT`` on  ``/v2/images/{imageId}/members/{memberId}``

  request body::

  { "status": "<STATUS_VALUE>" }

  where <STATUS_VALUE> is one of ``pending``, ``accepted``, or ``rejected``.
  The {memberId} is the tenant ID of the image member.


API消息本地化
------------
Glance支持HTTP消息的本地化。举个例子，一个HTTP客户端即使服务器本地（Locale）语言是英文也可以接收到中文的API信息。

如何使用它
*********
要获得本地化的API消息，HTTP客户端需要指定 **Accept-Language** 头来申明用什么语言翻译消息。关于Accept-Language更多的内容请参考 http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html

一个典型的API请求是类似下面这样子的::

   curl -i -X GET -H 'Accept-Language: zh' -H 'Content-Type: application/json'
   http://127.0.0.1:9292/v2/images/aaa

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
