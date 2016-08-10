#!/bin/bash
echo "Start converting Disk Image"

qemu-img convert -f qcow2 -O vdi /opt/image/wp5.qcow2 /opt/image/wp5.vdi