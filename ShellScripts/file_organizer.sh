#!/bin/bash
# ==============================================================================
# file_organizer.sh - Organize files in a directory into category subfolders.
#
# Usage:
#   ./file_organizer.sh [OPTIONS] <TARGET_DIR>
#
# Categories:
#   Documents, Images, Code, Archives, Media, Logs, Others
#
# Options:
#   -n, --dry-run    Preview moves without modifying files or directories.
#   -h, --help       Show this help message and exit.
# ==============================================================================

set -euo pipefail

DRY_RUN=false

print_usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] <TARGET_DIR>

Sorts top-level non-hidden files in TARGET_DIR into categorized subfolders
based on file extension while safely avoiding filename collisions.

Options:
  -n, --dry-run    Preview planned file moves without making changes
  -h, --help       Display this help message and exit

Example:
  $(basename "$0") --dry-run ~/Downloads
EOF
}

get_category() {
    local filename="$1"
    local ext=""

    if [[ "$filename" == *.* ]]; then
        ext="$(printf "%s" "${filename##*.}" | tr '[:upper:]' '[:lower:]')"
    fi

    case "$ext" in
        pdf|doc|docx|txt|md|rtf|odt|xls|xlsx|csv|ppt|pptx)
            printf "Documents"
            ;;
        jpg|jpeg|png|gif|svg|webp|bmp|ico)
            printf "Images"
            ;;
        py|sh|bash|js|ts|jsx|tsx|html|css|json|yaml|yml|xml|sql|c|cpp|h|java|go|rs)
            printf "Code"
            ;;
        zip|tar|gz|bz2|xz|tgz|7z|rar)
            printf "Archives"
            ;;
        mp3|wav|flac|aac|mp4|mkv|avi|mov|webm)
            printf "Media"
            ;;
        log)
            printf "Logs"
            ;;
        *)
            printf "Others"
            ;;
    esac
}

unique_destination_path() {
    local dest_dir="$1"
    local filename="$2"
    local candidate="${dest_dir}/${filename}"

    if [[ ! -e "$candidate" ]]; then
        printf "%s" "$candidate"
        return 0
    fi

    local stem="$filename"
    local ext=""
    if [[ "$filename" == *.* ]]; then
        stem="${filename%.*}"
        ext=".${filename##*.}"
    fi

    local counter=1
    while [[ -e "${dest_dir}/${stem}_${counter}${ext}" ]]; do
        ((counter++))
    done

    printf "%s" "${dest_dir}/${stem}_${counter}${ext}"
}

main() {
    local target_dir=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "Error: Unknown option '$1'" >&2
                print_usage >&2
                exit 1
                ;;
            *)
                if [[ -n "$target_dir" ]]; then
                    echo "Error: Only one TARGET_DIR may be provided." >&2
                    print_usage >&2
                    exit 1
                fi
                target_dir="$1"
                shift
                ;;
        esac
    done

    if [[ -z "$target_dir" && $# -gt 0 ]]; then
        target_dir="$1"
    fi

    if [[ -z "$target_dir" ]]; then
        echo "Error: TARGET_DIR is required." >&2
        print_usage >&2
        exit 1
    fi

    if [[ ! -d "$target_dir" ]]; then
        echo "Error: Target directory does not exist: '$target_dir'" >&2
        exit 1
    fi

    local abs_target script_name moved_count=0 skipped_count=0
    abs_target="$(cd "$target_dir" && pwd -P)"
    script_name="$(basename "$0")"

    echo "Organizing files in: $abs_target"
    if [[ "$DRY_RUN" == true ]]; then
        echo "Mode: DRY-RUN (no files will be moved)"
    fi

    shopt -s nullglob
    local entry filename category dest_dir dest_path
    for entry in "$abs_target"/*; do
        # Skip subdirectories and non-regular files (and the script itself if inside target).
        if [[ ! -f "$entry" ]]; then
            ((skipped_count++)) || true
            continue
        fi

        filename="$(basename "$entry")"
        if [[ "$filename" == "$script_name" ]]; then
            ((skipped_count++)) || true
            continue
        fi

        category="$(get_category "$filename")"
        dest_dir="${abs_target}/${category}"
        dest_path="$(unique_destination_path "$dest_dir" "$filename")"

        if [[ "$DRY_RUN" == true ]]; then
            echo "[DRY-RUN] $filename -> ${category}/$(basename "$dest_path")"
        else
            mkdir -p "$dest_dir"
            mv "$entry" "$dest_path"
            echo "Moved: $filename -> ${category}/$(basename "$dest_path")"
        fi
        ((moved_count++)) || true
    done
    shopt -u nullglob

    echo "Summary: ${moved_count} file(s) processed, ${skipped_count} non-file/skipped entries."
}

main "$@"
