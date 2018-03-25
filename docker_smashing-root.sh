#!/bin/bash


docker run -ti -p 3030:3030 \
 --name smashing1 \
 --add-host aspire.local:192.168.0.240 \
 -v=/home/gavin/dev/smashing/data/assets:/assets \
 -v=/home/gavin/dev/smashing/data/dashboards:/dashboards \
 -v=/home/gavin/dev/smashing/data/jobs:/jobs \
 -v=/home/gavin/dev/smashing/data/widgets:/widgets \
 -v=/home/gavin/dev/smashing/data/certs:/certs \
 smashing:latest
