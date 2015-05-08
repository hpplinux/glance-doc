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

镜像标识符（Identifier）
=====================

镜像通过符合以下签名的URL来唯一标识::

  <Glance Server Location>/v1/images/<ID>

这里 `<Glance Server Location>` 是Glance服务的资源地址，它知道镜像的信息，而 `<ID>` 是镜像的标识符。在Glance中镜像标识符是 *uuids* ，确保他们是 *全局唯一* 的。