#! /bin/bash

# register qemu to run arm code
# try --reset if it doesn't work. it'll unregister all first
docker run --rm --privileged multiarch/qemu-user-static:register # --reset

