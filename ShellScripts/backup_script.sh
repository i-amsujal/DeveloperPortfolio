#!/bin/bash
# ==============================================================================
# backup_script.sh - Create a compressed (.tar.gz) timestamped backup archive.
#
# Usage:
#   ./backup_script.sh [OPTIONS] <SOURCE_DIR> [DEST_DIR]
#
# Options:
#   -n, --dry-run       Preview the backup operation without writing files.
#   -k, --keep N        Keep only the N newest backups for this source folder.
#   -h, --help          Show this help message and exit.
# ==============================================================================

set -euo pipefail

DRY_RUN=false
KEEP_COUNT=0

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] <SOURCE_DIR> [DEST_DIR]

Creates a timestamped .tar.gz archive of SOURCE_DIR inside DEST_DIR
(default DEST_DIR: "\$HOME/backups").

Options:
  -n, --dry-run    Show what would be archived without creating files
  -k, --keep N     Retain only the N most recent backups (0 = keep all)
  -h, --help       Display this help message and exit

Example:
  $(basename "$0") ./Linux /tmp/backups
EOF
}

resolve_path() {
    (cd "$1" && pwd -P)
}

cleanup_old_backups() {
    local dest_dir="$1"
    local prefix="$2"
    local keep="$3"

    if [[ "$keep" -le 0 ]]; then
        return 0
    fi

    # List matching backups newest-first and remove any beyond the keep count.
    local backups=()
    while IFS= read -r file; do
        backups+=("$file")
    done < <(ls -1t "$dest_dir"/"${prefix}"_*.tar.gz 2>/dev/null || true)

    local total="${#backups[@]}"
    if [[ "$total" -gt "$keep" ]]; then
        local i
        for (( i = keep; i < total; i++ )); do
            if [[ "$DRY_RUN" == true ]]; then
                echo "[DRY-RUN] Would remove old backup: ${backups[$i]}"
            else
                rm -f "${backups[$i]}"
                echo "Removed old backup: ${backups[$i]}"
            fi
        done
    fi
}

main() {
    local positional=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -k|--keep)
                if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                    echo "Error: --keep requires a non-negative integer." >&2
                    exit 1
                fi
                KEEP_COUNT="$2"
                shift 2
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            --)
                shift
                positional+=("$@")
                break
                ;;
            -*)
                echo "Error: Unknown option '$1'" >&2
                print_usage >&2
                exit 1
                ;;
            *)
                positional+=("$1")
                shift
                ;;
        esac
    done

    if [[ "${#positional[@]}" -lt 1 || "${#positional[@]}" -gt 2 ]]; then
        echo "Error: SOURCE_DIR is required (and at most one DEST_DIR is allowed)." >&2
        print_usage >&2
        exit 1
    fi

    local source_arg="${positional[0]}"
    local dest_arg="${positional[1]:-$HOME/backups}"

    if [[ ! -d "$source_arg" ]]; then
        echo "Error: Source directory does not exist: '$source_arg'" >&2
        exit 1
    fi

    local source_abs source_parent source_base timestamp archive_name archive_path
    source_abs="$(resolve_path "$source_arg")"
    source_parent="$(dirname "$source_abs")"
    source_base="$(basename "$source_abs")"
    timestamp="$(date '+%Y%m%d_%H%M%S')"
    archive_name="backup_${source_base}_${timestamp}.tar.gz"

    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Source directory : $source_abs"
        echo "[DRY-RUN] Destination dir  : $dest_arg"
        echo "[DRY-RUN] Archive path     : ${dest_arg%/}/$archive_name"
        exit 0
    fi

    mkdir -p "$dest_arg"
    local dest_abs
    dest_abs="$(resolve_path "$dest_arg")"
    archive_path="${dest_abs}/${archive_name}"

    # Prevent tar from attempting to archive its own destination folder if nested.
    local tar_args=(-C "$source_parent" -czf "$archive_path")
    if [[ "$dest_abs" == "$source_abs" || "$dest_abs" == "$source_abs/"* ]]; then
        local rel_dest="${dest_abs#"$source_abs"/}"
        if [[ "$dest_abs" == "$source_abs" ]]; then
            tar_args+=(--exclude="${archive_name}")
        else
            tar_args+=(--exclude="${source_base}/${rel_dest}")
        fi
    fi
    tar_args+=("$source_base")

    echo "Creating backup of '$source_abs'..."
    tar "${tar_args[@]}"

    # Verify the generated archive can be read cleanly.
    tar -tzf "$archive_path" >/dev/null

    local archive_size
    archive_size="$(ls -lh "$archive_path" | awk '{print $5}')"
    echo "Backup completed successfully!"
    echo "Archive : $archive_path"
    echo "Size    : $archive_size"

    cleanup_old_backups "$dest_abs" "backup_${source_base}" "$KEEP_COUNT"
}

main "$@"
