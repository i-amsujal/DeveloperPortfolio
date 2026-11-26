#!/bin/bash
# ==============================================================================
# system_info.sh - Display a concise Linux/Unix system diagnostics summary.
#
# Usage:
#   ./system_info.sh [-o OUTPUT_FILE] [-h|--help]
#
# Options:
#   -o, --output FILE   Write the system report to FILE in addition to stdout.
#   -h, --help          Show this help message and exit.
# ==============================================================================

set -euo pipefail

OUTPUT_FILE=""

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Displays a formatted summary of host, OS, CPU, memory, disk, and network info.

Options:
  -o, --output FILE   Save the output report to FILE
  -h, --help          Display this help message and exit
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -o|--output)
                if [[ $# -lt 2 || -z "$2" ]]; then
                    echo "Error: --output requires a file path." >&2
                    exit 1
                fi
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            *)
                echo "Error: Unknown option '$1'" >&2
                print_usage >&2
                exit 1
                ;;
        esac
    done
}

print_section() {
    printf "\n[%s]\n" "$1"
    printf '%0.s-' {1..50}
    printf "\n"
}

get_os_name() {
    if [[ -r /etc/os-release ]]; then
        # shellcheck disable=SC1091
        (source /etc/os-release && printf "%s" "${PRETTY_NAME:-$NAME}")
    else
        uname -s
    fi
}

get_cpu_count() {
    if command -v nproc >/dev/null 2>&1; then
        nproc
    elif [[ -r /proc/cpuinfo ]]; then
        grep -c '^processor' /proc/cpuinfo
    elif [[ -n "${NUMBER_OF_PROCESSORS:-}" ]]; then
        printf "%s\n" "$NUMBER_OF_PROCESSORS"
    else
        printf "Unavailable\n"
    fi
}

get_memory_info() {
    if command -v free >/dev/null 2>&1; then
        free -h
    elif [[ -r /proc/meminfo ]]; then
        awk '
            /MemTotal:/     { total = $2 / 1024 }
            /MemAvailable:/ { avail = $2 / 1024 }
            /MemFree:/      { free  = $2 / 1024 }
            END {
                if (avail == 0) avail = free
                used = total - avail
                printf "Total: %.1f MiB | Used: %.1f MiB | Available: %.1f MiB\n", total, used, avail
            }
        ' /proc/meminfo
    else
        printf "Memory metrics unavailable on this platform.\n"
    fi
}

get_network_info() {
    if command -v ip >/dev/null 2>&1; then
        ip -brief addr
    elif command -v ifconfig >/dev/null 2>&1; then
        ifconfig | grep -E '^[a-zA-Z0-9]|inet '
    else
        printf "Network interface CLI (ip/ifconfig) not available.\n"
    fi
}

generate_report() {
    echo "=================================================="
    echo "              SYSTEM DIAGNOSTICS REPORT           "
    echo "=================================================="
    printf "Generated On : %s\n" "$(date '+%Y-%m-%d %H:%M:%S %Z')"

    print_section "Host & OS"
    printf "Hostname     : %s\n" "$(hostname)"
    printf "Current User : %s\n" "$(whoami)"
    printf "OS           : %s\n" "$(get_os_name)"
    printf "Kernel       : %s\n" "$(uname -srm)"
    printf "Shell        : %s\n" "${SHELL:-/bin/bash}"

    if command -v uptime >/dev/null 2>&1; then
        printf "Uptime       : %s\n" "$(uptime -p 2>/dev/null || uptime)"
    fi

    print_section "CPU & Memory"
    printf "CPU Cores    : %s\n" "$(get_cpu_count)"
    get_memory_info

    print_section "Disk Usage"
    if command -v df >/dev/null 2>&1; then
        df -h
    else
        printf "df command unavailable.\n"
    fi

    print_section "Network Interfaces"
    get_network_info
    echo ""
}

main() {
    parse_args "$@"

    if [[ -n "$OUTPUT_FILE" ]]; then
        local out_dir
        out_dir="$(dirname "$OUTPUT_FILE")"
        mkdir -p "$out_dir"
        generate_report | tee "$OUTPUT_FILE"
        echo "Report saved to: $OUTPUT_FILE"
    else
        generate_report
    fi
}

main "$@"
