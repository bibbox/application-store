#!/bin/bash
docker build -t bibbox/qemu .

docker run -t -i --name convertdisk -v /Users/reihsr/Downloads/wp5.debian.qcow2:/opt/image/wp5.qcow2 -v /Users/reihsr/Documents/BiBBox/wp5.vdi:/opt/image/wp5.vdi bibbox/qemu /bin/bash

docker rm convertdisk
