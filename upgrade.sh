#!/bin/bash

docker pull tobegit3hub/glance-doc

docker stop `docker ps -q`

sudo docker run -d -p 80:80 tobegit3hub/glance-doc

