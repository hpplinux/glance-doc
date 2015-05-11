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

安装
====

从包（Packages）中安装
~~~~~~~~~~~~~~~~~~~~

按照以下的指示安装Glance最新的发布版。

Debian, Ubuntu
##############

1. 将Glance PPA加到你的sources.lst::

   $> sudo add-apt-repository ppa:glance-core/trunk
   $> sudo apt-get update

2. 安装Glance::

   $> sudo apt-get install glance

Red Hat, Fedora
###############

只有RHEL 6、Fedora 18和更新的发布版有必需的组件。
在RHEL 6中需要开启（Enable）EPEL仓库（epository）。

安装Glance::

   $ su -
   # yum install openstack-glance

openSUSE, SLE
#############

openSUSE 13.2, SLE 12, and the rolling release Factory needs an extra
repository enabled to install all the OpenStack packages.
openSUSE 13.2、SLE 12和更新的发布版（Rolling Release Factory）需要开启额外的仓库来安装OpenStack包。

在这个地址搜索合适的仓库 `Cloud:OpenStack:Master <https://build.opensuse.org/project/repositories/Cloud:OpenStack:Master>`_ project. For example, for openSUSE 13.2:

1. 添加OpenStack主仓库（Master Repository）::

   $ sudo zypper ar -f -g http://download.opensuse.org/repositories/Cloud:/OpenStack:/Master/openSUSE_13.2/ OpenStack
   $ sudo zypper ref

2. 安装Glance::

   $ sudo zypper in openstack-glance

从源码压缩包（Tarball）中安装
~~~~~~~~~~~~~~~~~~~~~~~~~

要从Launchpad Bazaar仓库安装最新版的Glance，请按照以下的指令。

1. 从这个地址获取压缩包 `Launchpad <http://launchpad.net/glance/+download>`_

2. 解压这个压缩包::

   $> tar -xzf <FILE>

3. 跳转到包路径并且编译和安装::

   $> cd glance-<RELEASE>
   $> sudo python setup.py install

从Git中安装
~~~~~~~~~~~~~~~~~~~

要从GitHub仓库安装最新版的Glance，请按照以下的指令。

Debian, Ubuntu
##############

1. 安装Git和它的依赖::

   $> sudo apt-get install git
   $> sudo apt-get build-dep glance

.. 注意::

   如果你想在本地构建Glance文档，你还需要安装python-sphinx包。

2. 从GitHub下载（Clone）Glance主干（Trunk）分支::

   $> git clone git://github.com/openstack/glance
   $> cd glance

3. 安装Glance::

   $> sudo python setup.py install

Red Hat, Fedora
###############

在Fedora中，大部分开发者和几乎所有用户都会安装包。下面的指令不是常用的，而且它们经常用在用一次就抛弃（Throw-away）的虚拟机中。

由于普通的构建依赖会由RPM的机制解决，这里没有一行命令的解决办法来安装Git源码仓库需要的所有东西。通常的做法是在合适的发行版中openstack-glance的specfile中搜索 *BuildRequires:* 来发现所有的依赖。

举个例子，如果是Fedora 16就这样做::

   $ su -
   # yum install git
   # yum install python2-devel python-setuptools python-distutils-extra
   # yum install python-webob python-eventlet
   # yum install python-virtualenv

构建Glance::

   $ python setup.py build

如果出现了缺失的模块，使用yum安装然后重新尝试构建。

.. 注意::

   如果你想在本地构建Glance文档，你还需要安装python-sphinx和graphviz包，然后运行"python setup.py build_sphinx"。由于依赖python-sphinx 1.0及更新的特性，文档只能在Fedora 15以及更新版中才能构建。

测试构建效果::

   $ ./run_tests.sh -s

一旦Glance构建并测试过，安装这个::

   $ su -
   # python setup.py install

openSUSE, SLE
#############

在openSUSE和SLE（对工厂也是有效的）中，我们可以使用Zypper来安装所有构建所需的依赖。

1. 安装Git和它的依赖::

   $ sudo zypper install git
   $ sudo zypper source-install -d openstack-glance

.. 注意::

   如果你想在本地构建Glance文档，你还需要安装python-sphinx和graphviz包。

2. 从GitHub下载（Clone）Glance主干（Trunk）分支::

   $ git clone git://github.com/openstack/glance
   $ cd glance

3. 安装Glance::

   $ sudo python setup.py install
