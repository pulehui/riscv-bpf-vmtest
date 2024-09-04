<!--
SPDX-License-Identifier: Apache-2.0
-->

# riscv bpf vmtest

To speed up testing and avoid various dependency issues, it is recommended to run vmtest in a Docker container. Before running vmtest, we need to prepare Docker container and local rootfs image. The overall steps are as follows:

1. Use script [0] to build local rootfs image and copy to <rootfs_dir>:
```
sudo ./mkrootfs_debian.sh --arch riscv64 --distro noble
```
2. Create the Docker container:
```
docker build -f Dockerfile.riscv-bpf-vmtest . -t riscv-bpf-vmtest
```
now we will have a container named "riscv-bpf-vmtest".

3. Run the container, pointing to your Linux kernel source tree and rootfs dir:
```
docker run --tty --interactive --volume <kernel_src_dir>:/workspace --volume <rootfs_dir>:/rootfs --privileged riscv-bpf-vmtest:latest /bin/bash
```
4. Enter /workspace and run vmtest in the container using:
```
PLATFORM=riscv64 CROSS_COMPILE=riscv64-linux-gnu- \
    tools/testing/selftests/bpf/vmtest.sh \
	-l <path of local rootfs image> -- \
        ./test_progs -d \
            \"$(cat tools/testing/selftests/bpf/DENYLIST.riscv64 \
                | cut -d'#' -f1 \
                | sed -e 's/^[[:space:]]*//' \
                      -e 's/[[:space:]]*$//' \
                | tr -s '\n' ','\
            )\"
```

Link: https://github.com/libbpf/ci/blob/main/rootfs/mkrootfs_debian.sh [0]
