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

控制Glance服务器
==============

这部分描述了启动、停止、重新加载（Reload）Glance服务器程序的方法。

启动服务器
---------

有两种方法可以启动Glance服务器（通过API服务器或者Registry服务器）：

* 手动调用服务器程序

* 使用包装过服务器守护进程的 ``glance-control`` 服务器

我们推荐使用第二种方法。

手动启动服务器
~~~~~~~~~~~~

第一种方法是直接调用服务器程序，传递命令行参数并且有一个 ``paste.deploy`` 配置文件的参数，用于配置服务器应用。

.. 注意::

  Glance直接部署在 ``etc/`` 目录，这个目录包含了简单的 ``paste.deploy`` 配置文件，你可以拷贝到标准的配置目录然后被你采用。特别的是，bind_host是必须合理地设置。

如果你在命令行 `没有` 指定配置文件，Glance会尽力在以下的其中一个目录寻找配置文件，找到第一个它就会停止：

* ``$CWD``
* ``~/.glance``
* ``~/``
* ``/etc/glance``
* ``/etc``

搜索的文件名依赖于服务器应用的名字。所以，如果你启动API服务器，它就会搜索 ``glance-api.conf`` ，否则搜索 ``glance-registry.conf`` 。

如果找不到配置文件，你会看到错误，就像这样：

  $> glance-api
  ERROR: Unable to locate any configuration file. Cannot load application glance-api

这是个例子，展示了你可以怎样在Shell里启动 ``glance-api`` 服务器和 ``glance-registry`` 。::

  $ sudo glance-api --config-file glance-api.conf --debug &
  jsuh@mc-ats1:~$ 2011-04-13 14:50:12    DEBUG [glance-api] ********************************************************************************
  2011-04-13 14:50:12    DEBUG [glance-api] Configuration options gathered from config file:
  2011-04-13 14:50:12    DEBUG [glance-api] /home/jsuh/glance-api.conf
  2011-04-13 14:50:12    DEBUG [glance-api] ================================================
  2011-04-13 14:50:12    DEBUG [glance-api] bind_host                      65.114.169.29
  2011-04-13 14:50:12    DEBUG [glance-api] bind_port                      9292
  2011-04-13 14:50:12    DEBUG [glance-api] debug                          True
  2011-04-13 14:50:12    DEBUG [glance-api] default_store                  file
  2011-04-13 14:50:12    DEBUG [glance-api] filesystem_store_datadir       /home/jsuh/images/
  2011-04-13 14:50:12    DEBUG [glance-api] registry_host                  65.114.169.29
  2011-04-13 14:50:12    DEBUG [glance-api] registry_port                  9191
  2011-04-13 14:50:12    DEBUG [glance-api] verbose                        False
  2011-04-13 14:50:12    DEBUG [glance-api] ********************************************************************************
  2011-04-13 14:50:12    DEBUG [routes.middleware] Initialized with method overriding = True, and path info altering = True
  2011-04-13 14:50:12    DEBUG [eventlet.wsgi.server] (21354) wsgi starting up on http://65.114.169.29:9292/

  $ sudo glance-registry --config-file glance-registry.conf &
  jsuh@mc-ats1:~$ 2011-04-13 14:51:16     INFO [sqlalchemy.engine.base.Engine.0x...feac] PRAGMA table_info("images")
  2011-04-13 14:51:16     INFO [sqlalchemy.engine.base.Engine.0x...feac] ()
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Col ('cid', 'name', 'type', 'notnull', 'dflt_value', 'pk')
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (0, u'created_at', u'DATETIME', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (1, u'updated_at', u'DATETIME', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (2, u'deleted_at', u'DATETIME', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (3, u'deleted', u'BOOLEAN', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (4, u'id', u'INTEGER', 1, None, 1)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (5, u'name', u'VARCHAR(255)', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (6, u'disk_format', u'VARCHAR(20)', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (7, u'container_format', u'VARCHAR(20)', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (8, u'size', u'INTEGER', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (9, u'status', u'VARCHAR(30)', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (10, u'is_public', u'BOOLEAN', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (11, u'location', u'TEXT', 0, None, 0)
  2011-04-13 14:51:16     INFO [sqlalchemy.engine.base.Engine.0x...feac] PRAGMA table_info("image_properties")
  2011-04-13 14:51:16     INFO [sqlalchemy.engine.base.Engine.0x...feac] ()
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Col ('cid', 'name', 'type', 'notnull', 'dflt_value', 'pk')
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (0, u'created_at', u'DATETIME', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (1, u'updated_at', u'DATETIME', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (2, u'deleted_at', u'DATETIME', 0, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (3, u'deleted', u'BOOLEAN', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (4, u'id', u'INTEGER', 1, None, 1)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (5, u'image_id', u'INTEGER', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (6, u'key', u'VARCHAR(255)', 1, None, 0)
  2011-04-13 14:51:16    DEBUG [sqlalchemy.engine.base.Engine.0x...feac] Row (7, u'value', u'TEXT', 0, None, 0)

  $ ps aux | grep glance
  root     20009  0.7  0.1  12744  9148 pts/1    S    12:47   0:00 /usr/bin/python /usr/bin/glance-api glance-api.conf --debug
  root     20012  2.0  0.1  25188 13356 pts/1    S    12:47   0:00 /usr/bin/python /usr/bin/glance-registry glance-registry.conf
  jsuh     20017  0.0  0.0   3368   744 pts/1    S+   12:47   0:00 grep glance

通过简单的 ``--config-file`` 选项（ ``etc/glance-api.conf`` 和  ``etc/glance-registry.conf`` 在上面的例子中使用）指定配置文件，还有其他参数你可以使用。（在上面 ``--debug`` 用于展示服务器启动时的调试信息。通过 ``--help`` 可以看到命令行的所有可用参数）。

 ``paste.deploy``配置文件可以找到个更多配置服务器的信息，在这个章节可以脏多熬
:doc:`Configuring Glance servers <configuring>`

注意服务器可以通过标准的Shell后台标示符（Indicator） ``&`` 来作为 `守护进程` ，这是前面的例子。最常见的用例是，我们建议使用 ``glance-control`` 封装程序来启动守护进程。下面有使用 ``glance-control`` 的详细内容。

使用 ``glance-control`` 程序来启动服务器
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

启动Glance服务器的第二种方法是使用 ``glance-control`` 程序。 ``glance-control`` 是一个封装过的脚本允许用户启动、停止、重启和重新加载Glance服务器，并且更加有效、自动化和脚本化。

通过 ``glance-control`` 启动的服务器都是 `守护进程` ，这意味着服务器进程都是在后台运行的。

要通过 ``glance-control`` 启动Glance服务器，只需简单地使用 "start"来调用 ``glance-control`` 。通过 "start"启动服务器的方法如下::

  $> sudo glance-control [OPTIONS] <SERVER> start [CONFPATH]

.. 注意::

  目前你必须使用  ``sudo`` 程序来运行 ``glance-control`` ，而服务端的Pid文件是写在/var/run/glance/目录。

这里有个例子显示了如何使用 ``glance-control`` 的封装脚本::

  $ sudo glance-control api start glance-api.conf
  Starting glance-api with /home/jsuh/glance.conf

  $ sudo glance-control registry start glance-registry.conf
  Starting glance-registry with /home/jsuh/glance.conf

  $ ps aux | grep glance
  root     20038  4.0  0.1  12728  9116 ?        Ss   12:51   0:00 /usr/bin/python /usr/bin/glance-api /home/jsuh/glance-api.conf
  root     20039  6.0  0.1  25188 13356 ?        Ss   12:51   0:00 /usr/bin/python /usr/bin/glance-registry /home/jsuh/glance-registry.conf
  jsuh     20042  0.0  0.0   3368   744 pts/1    S+   12:51   0:00 grep glance


 ``glance-control`` 启动Glance服务器程序会使用相同的配置文件，而且你可以在启动服务器的时候指定（像上面的例子）一个配置文件。

为了让你的Glance服务可以监控非预期的推出和必要时的重启（Respawn），请使用下面的选项：


  $ sudo glance-control [service] start --respawn ...


注意这会让 ``glance-control`` 自己保持一直运行。同样要注意特意地停止服务不会引起重启，迅速地重启服务（进程在上次启动一秒内挂了）也不会。

Glance服务默认的输出会在 ``glance-control`` 启动时丢弃。通过syslog可以获得这类输出，使用以下的选项：

  $ sudo glance-control --capture-output ...


Stopping a server
停止服务器
-----------------

如果你手动启动Glance服务器并且没有使用 ``&`` 后台执行函数，通过输入``Ctrl-C``简单的给服务器进程发送中止信号即可。

如果你使用 ``glance-control`` 程序来启动Glance服务器，你可以使用 ``glance-control`` 程序来停止它。简单地按照下面的指示::

  $> sudo glance-control <SERVER> stop

就像这个例子那样::

  $> sudo glance-control registry stop
  Stopping glance-registry  pid: 17602  signal: 15

重启服务器
---------

你可以通过 ``glance-control`` 程序来重启服务器，就像这里演示的那样::

  $> sudo glance-control registry restart etc/glance-registry.conf
  Stopping glance-registry  pid: 17611  signal: 15
  Starting glance-registry with /home/jpipes/repos/glance/trunk/etc/glance-registry.conf

重新加载服务器
------------

你可以通过 ``glance-control`` 程序来重新加载服务器，就像这里演示的那样::

  $> sudo glance-control api reload
  Reloading glance-api (pid 18506) with signal(1)

重新加载会给主（Master）进程发送SIGHUP信号，并且在不暂停正在运行的服务器的情况下（假定bind_host和bind_port都没变）选择新的配置设置。