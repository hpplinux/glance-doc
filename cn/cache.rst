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

Glance镜像缓存
=============

Glance API服务器可以配置使用可选的本地镜像缓存。本地镜像缓存保存了镜像文件的拷贝，本质上是支持多个API服务器提供同一个镜像文件的服务，由于同一镜像文件的服务终端（Endpoint）的增加来提高可拓展性。

这个本地镜像缓存对终端用户是透明的 -- 换句话说，终端用户并不知道Glance API是通过本地缓存还是实际的后端存储系统来传输镜像文件。

管理Glance镜像缓存
----------------

当请求 ``GET /images/<IMAGE_ID>`` 成功将镜像文件自动放到镜像缓存中时，镜像缓存没有自动被管理。这里我们描述了在Glance API服务器如何管理本地镜像缓存和自动化管理这些缓存的基础。

控制镜像缓存的增长
~~~~~~~~~~~~~~~

镜像缓存有一个可配置的最大值（ ``image_cache_max_size`` 的配置项）。 ``image_cache_max_size`` 是一个上限，如果正在运行，它开始清理镜像缓存。然后，当镜像调用 ``GET /images/<IMAGE_ID>`` 成功返回时，镜像缓存自动地将将镜像文件写到它的缓存中，无论最终写的镜像缓存文件大小是否超过 ``image_cache_max_size`` 。为了让镜像缓存等于或低于最大的缓存大小，你需要执行 ``glance-cache-pruner`` 。

推荐的实践是使用 ``cron`` 在一定时间间隔后启动 ``glance-cache-pruner`` 。

清理镜像缓存
~~~~~~~~~~

随着时间增长，镜像缓存会积累延后（Stalled）或无效状态的镜像文件。延后镜像文件时由于写镜像缓存时没有完成导致的。无效镜像文件时由于镜像没有很好得写到磁盘导致的。

要移除这些类型的文件， ``glance-cache-cleaner`` 可执行程序。

推荐的时间是使用 ``cron`` 在非常规（Semi-regular）间隔内启动 ``glance-cache-cleaner`` 。

预读镜像到镜像缓存
~~~~~~~~~~~~~~~

一些安装会有基本（有时称为“黄金”）镜，他们通常用于启动虚拟机。当启动一个新的API服务器，管理员希望提前加载这些镜像文件到本地镜像缓存中，以保证这些流行（Popular）的镜像都能从本地缓存中读到。

要将镜像添加到预取队列，你可以使用下面方法的任意一种：

 * 如果在应用流水线（Pipeline）中 ``cache_manage`` 中间件是已经启用的，你可以调用 ``PUT /queued-images/<IMAGE_ID>`` 把标识符为 ``<IMAGE_ID>`` 的镜像添加到队列中。

   可选的是，你可以使用 ``glance-cache-manage`` 程序来添加镜像到队列。这个程序可以运行在不包含这个镜像混存的主机上。使用示例如下::

     $> glance-cache-manage --host=<HOST> queue-image <IMAGE_ID>

   这会将标识符为 ``<IMAGE_ID>`` 的镜像添加到预取队列中。

一旦你把你想要预取的镜像添加到队列，调用 ``glance-cache-prefetcher`` 可执行程序将会并发地预取队列中所有的镜像，并且把每个镜像的日志的结果记录到日志中。

查找哪些镜像在镜像缓存
~~~~~~~~~~~~~~~~~~

你可以使用以下的方法来查看什么镜像在镜像缓存中：

  * 如果在应用流水线（Pipeline）中 ``cache_manage`` 中间件是已经启用的，你可以调用 ``GET /cached-images`` 查看一个包含缓存镜像的用JSON序列化的列表，还包含每个镜像的缓存命中次数、镜像的大小和上次访问的时间。

    可选的是，你可以使用 ``glance-cache-manage`` 程序。这个程序可以在不包含这个镜像缓存的主机上运行。使用示例如下::

    $> glance-cache-manage --host=<HOST> list-cached

  * 你可以在类Unix（\*nix）系统中定位下面的调用（必须在包含此镜像缓存的主机上::

      $> ls -lhR $IMAGE_CACHE_DIR

     ``$IMAGE_CACHE_DIR`` 是配置文件中 ``image_cache_dir`` 变量的值。

    注意使用这个方法镜像的缓存命中次数并没有显示出来。

手动从镜像胡那村中移除镜像
~~~~~~~~~~~~~~~~~~~~~

如果在应用流水线（Pipeline）中 ``cache_manage`` 中间件是已经启用的，你可以调用``DELETE /cached-images/<IMAGE_ID>`` 来将标识符为 ``<IMAGE_ID>`` 的镜像文件移出缓存。

可选的是，你可以使用 ``glance-cache-manage`` 程序。使用示例如下::

  $> glance-cache-manage --host=<HOST> delete-cached-image <IMAGE_ID>
