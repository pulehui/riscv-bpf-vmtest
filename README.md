<!--
SPDX-License-Identifier: Apache-2.0
-->

# riscv bpf vmtest

To speed up testing and avoid various dependency issues, it is recommended to run vmtest in a Docker container. Before running vmtest, we need to prepare Docker container and local rootfs image. The overall steps are as follows:

1. Install dependencies. Make sure you are in ubuntu resolute.
```
sudo apt install debootstrap qemu-user zstd
```

2. Use mkrootfs script (fetch from libbpf/ci) to build local rootfs image or use prebuild rootfs in `image` path, and then copy to <rootfs_dir>:
```
cd mkrootfs
sudo ./mkrootfs_debian.sh --arch riscv64 --distro resolute
```

3. Create the Docker container:
```
sudo docker build -f Dockerfile.riscv-bpf-vmtest . -t riscv-bpf-vmtest
```
now we will have a container named "riscv-bpf-vmtest".

4. Run the container, pointing to your Linux kernel source tree and rootfs dir:
```
sudo docker run --tty --interactive --privileged \
    --volume <kernel_src_dir>:/workspace \
    --volume <rootfs_dir>:/rootfs \
    riscv-bpf-vmtest:latest /bin/bash
```

5. Enter /workspace and run vmtest in the container using:
```
PLATFORM=riscv64 CROSS_COMPILE=riscv64-linux-gnu- \
    tools/testing/selftests/bpf/vmtest.sh \
      -l <path of libbpf-vmtest-rootfs.*.tar.zst> -- \
        ./test_progs -w 0 -d \
            \"$(cat tools/testing/selftests/bpf/DENYLIST.riscv64 \
                | cut -d'#' -f1 \
                | sed -e 's/^[[:space:]]*//' \
                      -e 's/[[:space:]]*$//' \
                | tr -s '\n' ','\
            )\"
```
