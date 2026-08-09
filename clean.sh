#!/bin/bash

# --- Configuration ---
# The folder containing the clean, unmodified kernel source
CLEAN_DIR="android_kernel_samsung_a23xq"

# The folder containing the patched kernel that needs to be fixed.
# Change this if your patched folder has a different name!
PATCHED_DIR="$PWD" 

# --- File Lists ---
# Files that were created by the patch (need to be deleted)
NEW_FILES=(
    "fs/susfs.c"
    "include/linux/susfs.h"
    "include/linux/susfs_def.h"
)

# Files that were modified by the patch (need to be restored)
RESTORE_FILES=(
    "fs/Makefile"
    "fs/namei.c"
    "fs/namespace.c"
    "fs/proc_namespace.c"
    "fs/readdir.c"
    "fs/stat.c"
    "fs/statfs.c"
    "fs/notify/fdinfo.c"
    "fs/proc/base.c"
    "fs/proc/cmdline.c"
    "fs/proc/fd.c"
    "fs/proc/task_mmu.c"
    "kernel/kallsyms.c"
    "kernel/sys.c"
    "mm/memory.c"
    "security/selinux/avc.c"
)

echo "Starting susfs removal process..."

# 1. Check if both directories exist
if [ ! -d "$CLEAN_DIR" ]; then
    echo "Error: Clean directory '$CLEAN_DIR' not found!"
    exit 1
fi

if [ ! -d "$PATCHED_DIR" ]; then
    echo "Error: Patched directory '$PATCHED_DIR' not found! Please update the PATCHED_DIR variable in the script."
    exit 1
fi

# 2. Delete the newly created susfs files
echo ""
echo "--- Deleting new susfs files ---"
for file in "${NEW_FILES[@]}"; do
    target_file="$PATCHED_DIR/$file"
    if [ -f "$target_file" ]; then
        rm "$target_file"
        echo "Deleted: $file"
    else
        echo "Skipped (not found): $file"
    fi
done

# 3. Restore the modified files from the clean directory
echo ""
echo "--- Restoring original files ---"
for file in "${RESTORE_FILES[@]}"; do
    source_file="$CLEAN_DIR/$file"
    target_file="$PATCHED_DIR/$file"
    
    if [ -f "$source_file" ]; then
        cp "$source_file" "$target_file"
        echo "Restored: $file"
    else
        echo "Warning (Source file missing in $CLEAN_DIR): $file"
    fi
done

echo ""
echo "Done! The susfs patch has been successfully reverted."
