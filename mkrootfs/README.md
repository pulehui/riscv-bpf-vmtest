<!--
SPDX-License-Identifier: Apache-2.0
-->

# build rootfs for bpf selftests

1. Install dependencies. Make sure you are in ubuntu resolute.
```
sudo apt install debootstrap qemu-user zstd
```

2. Use mkrootfs script (fetch from libbpf/ci) to build local rootfs image:
```
sudo ./mkrootfs_debian.sh --arch riscv64 --distro resolute
```
