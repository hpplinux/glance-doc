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

镜像状态
=======

在Glance中镜像可以是以下的任意一种状态：

* ``在队列中（queued）``

  每个镜像的镜像标识符预留在Glance注册表（registry）中。在创建的时候不会上传镜像数据到Glance，并且镜像大小被显式设为0。

* ``正在保存（saving）``

  表明镜像原始数据正在上传到Glance。当镜像调用 `POST /images` 并且 `x-image-meta-location` 头出现时镜像就注册了，这个镜像将永远不会再 `正在保存` 状态（因为镜像数据已经在其他位置可用了）。

* ``激活的（active）``

  表明镜像在Glance完全可用了。当镜像数据已经上传，或者镜像大小在创建时显式设为0就会发生。

* ``被停止的（killed）``

  表明在上传镜像数据时发生了错误，并且镜像是不可读的。

* ``被删除的（deleted）``

  Glance保留过镜像的信息，但它不再可用了。在这个状态的镜像在以后将会自动被移除。

* ``排队删除中（pending_delete）``

  这更 `被删除的` 很像，然后Glance还没有完全移出镜像数据。在这个状态的镜像是不可恢复的。

.. figure:: /images/image_status_transition.png
   :figwidth: 100%
   :align: center
   :alt: Image状态转移

   这展示了镜像是如何从一个状态转换成下一个状态的。

   * 从零开始添加一个或多个地址。

   * 通过PATCH方法将一个或多个地址全部移除，这只在v2中支持。

任务（Task）状态
==============

Glance中任务可以在以下任意一个状态：

* ``等待中（pending）``

  每个任务的任务标识符都在Glance中保留。当前还没开始执行。

* ``正在处理（processing）``

  任务已经被底层的执行器（Executor）选中，并且根据任务类型使用Glance后端处理罗辑执行中。
  The task has been picked up by the underlying executor and is being run
  using the backend Glance execution logic for that task type.

* ``成功（success）``

  表明任务在Glance中已经成功执行。任务的 ``result`` 字段展示了结果的更多细节。

* ``失败（failure）``

  表明在任务执行过程中发生了错误，并且它不能继续执行。任务的 ``message`` 字段展示了具体的错误。
