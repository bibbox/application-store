#!/bin/bash
docker build -t bibbox/qemu .

docker run -t -i --name convertdisk -v /Users/reihsr/Downloads/wp5.debian.qcow2:/opt/image/wp5.qcow2 -v /Volumes/Backup/imagesconverted:/opt/image/output bibbox/qemu /bin/bash

docker rm convertdisk
