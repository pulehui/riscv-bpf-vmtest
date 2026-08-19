#!/bin/bash
set -e

show_usage() {
    echo "Usage: $0 {build | run [directory]}"
    echo "  build            - Build Docker image using Dockerfile.riscv-bpf-vmtest"
    echo "  run [directory]  - Run container, mount directory (default: current dir) as /workspace"
}

case "$1" in
    build)
        sudo docker build -f Dockerfile.riscv-bpf-vmtest . -t riscv-bpf-vmtest
        ;;
    run)
        if [ -z "$2" ]; then
            workspace="$(pwd)"
        else
            workspace="$(realpath "$2" 2>/dev/null || readlink -f "$2")"
            if [ -z "$workspace" ] || [ ! -d "$workspace" ]; then
                echo "Error: Directory '$2' does not exist or cannot be resolved." >&2
                exit 1
            fi
        fi

        sudo docker run --tty --interactive --privileged \
            --volume "${workspace}:/workspace" \
            riscv-bpf-vmtest:latest /bin/bash
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
