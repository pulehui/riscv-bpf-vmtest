<!--
SPDX-License-Identifier: Apache-2.0
-->

# riscv bpf vmtest

To speed up testing and avoid various dependency issues, it is recommended to run vmtest in a Docker container. Before running vmtest, we need to prepare Docker container and local rootfs image. The overall steps are as follows:

1. Create the Docker container:
```
bash rvbpf.sh build
```
now we will have a container named "riscv-bpf-vmtest".

2. Run the container, mount linux kernel source path (default: current path) as /workspace in docker:
```
bash rvbpf.sh run [workspace]
```

3. Enter /workspace and run vmtest in the container using:
```
PLATFORM=riscv64 CROSS_COMPILE=riscv64-linux-gnu- \
    tools/testing/selftests/bpf/vmtest.sh \
      -l /root/libbpf-vmtest-rootfs-2026.08.17-resolute-riscv64.tar.zst -- \
        ./test_progs -w 0 -d \
            \"$(cat tools/testing/selftests/bpf/DENYLIST.riscv64 \
                | cut -d'#' -f1 \
                | sed -e 's/^[[:space:]]*//' \
                      -e 's/[[:space:]]*$//' \
                | tr -s '\n' ','\
            )\"
```
