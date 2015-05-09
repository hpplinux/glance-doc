..
      Copyright 2011-2013 OpenStack Foundation
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

通知
====

在镜像的生命周期中几种事件都能生成通知。这些通知能用于审计（Audit）和定位错误等等。

通知驱动
-------

* 日志

  这个驱动使用标准的Python日志系统，它通过log_file配置项指定的文件结束通知。

* 消息

  这个策略向oslo.messaging配置项指定的消息队列发送通知。

* 无操作（noop）

  这个策略不产生通知。它是默认的策略。

通知类型
-------

* ``image.create``

  在Glance创建镜像记录的时候发送。创建镜像记录与上传镜像数据是相互独立的。


* ``image.prepare``

  当Glance开始上传镜像数据到后端存储时发送。

* ``image.upload``

  当Glance完成镜像数据上传到后端存储时发送。

* ``image.activate``

  当镜像变成 `active` 状态的时候发送。这在Glance能够定位镜像数据时发生。

* ``image.send``

  当镜像完全发送给消费者时发送。

* ``image.update``

  当镜像记录在Glance中更新时发送。

* ``image.delete``

  当镜像从Glance中删除时发送。

* ``task.run``

  当任务被执行器（Executor）选择去运行时发送。

* ``task.processing``

  当任务被发送给执行器开始执行时发送。

* ``task.success``

  当任务成功完成时发送。

* ``task.failure``

  当任务失败时发送。

内容
----

每个消息都包含一些属性。

* message_id

  表示消息的UUID。

* publisher_id

  产生消息的Glance实例的主机名。

* event_type

  产生消息的时间。

* priority

  WARN、INOF或ERROR其中一个。

* timestamp

  事件产生的UTC时间戳。

* payload

  事件类型的数据内容（Specific）。

承载（Playload）
--------------

* image.send

  INFO、WARN和ERROR事件的承载包含以下内容：

  image_id
    镜像的ID（UUID）
  owner_id
    拥有此镜像的租户（Tenant）或者用户的ID（string）
  receiver_tenant_id
    接收镜像的租户账号ID（string）
  receiver_user_id
    接收镜像的用户账号ID（string）
  destination_ip
    目标IP。
  bytes_sent
    实际发送的Byte数

* image.create

  对于INFO事件，这是镜像元数据。而WARN和ERROR事件包含了承载中的文本信息。

* image.prepare

  对于INFO事件，这是镜像元数据。而WARN和ERROR事件包含了承载中的文本信息。

* image.upload

  对于INFO事件，这是镜像元数据。而WARN和ERROR事件包含了承载中的文本信息。

* image.activate

  对于INFO事件，这是镜像元数据。而WARN和ERROR事件包含了承载中的文本信息。

* image.update

  对于INFO事件，这是镜像元数据。而WARN和ERROR事件包含了承载中的文本信息。

* image.delete

  对于INFO事件，这是镜像元数据。而WARN和ERROR事件包含了承载中的文本信息。

* task.run

  INFO、WARN和ERROR事件的承载包含以下内容：

  task_id
    镜像的ID（UUID）
  owner
    创建这个任务的租户或者用户ID（string）
  task_type
    任务的类型。例如，task_type是"import"。string）
  status
    任务的状态。状态可以是"pending"、"processing"、"success"或者"failure"。（string）
  task_input
    当尝试创建一个任务时提供的输入。（dict）
  result
    成功执行的任务的结果输出。（dict）
  message
    如果任务失败了它显示的消息。如果成功了就为空。（string）
  expires_at
    任务对用户不可见时的UTC时间。（string）
  created_at
    任务创建时的UTC时间。（string）
  updated_at
    任务最后更新的UTC时间。（string）

  异常是:-
    对于INFO事件，这是包含结果的任务dict数据而且消息为空。而WARN和ERROR事件包含了承载中的文本信息。

* task.processing

  对于INFO事件，这是包含结果的任务dict数据而且消息为空。而WARN和ERROR事件包含了承载中的文本信息。

* task.success

  对于INFO事件，这是包含结果的任务dict数据而且消息为空，而result是dict。而WARN和ERROR事件包含了承载中的文本信息。

* task.failure

  对于INFO事件，这是包含结果的任务dict数据而且消息为文本。而WARN和ERROR事件包含了承载中的文本信息。