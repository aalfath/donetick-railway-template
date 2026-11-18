#!/bin/sh
# Start Donetick with all of its state under one data directory (a Railway volume).
#   $DATA_DIR/donetick.db              SQLite database
#   $DATA_DIR/config/selfhosted.yaml   config file, generated on first start; edit it to customise
#   $DATA_DIR/uploads/                 task photos and profile pictures
# Any setting in the config file can be overridden with a DT_* variable
# (for example DT_JWT_SECRET, DT_EMAIL_HOST, DT_SERVER_PUBLIC_HOST).
set -eu

DATA_DIR="${DATA_DIR:-${RAILWAY_VOLUME_MOUNT_PATH:-/data}}"
mkdir -p "$DATA_DIR/config" "$DATA_DIR/uploads"

# Railway routes the public domain to $PORT.
export DT_SERVER_PORT="${DT_SERVER_PORT:-${PORT:-2021}}"
export DT_SQLITE_PATH="${DT_SQLITE_PATH:-$DATA_DIR/donetick.db}"

# Keep uploads on the volume instead of the default (an unconfigured S3 bucket).
export DT_STORAGE_STORAGE_TYPE="${DT_STORAGE_STORAGE_TYPE:-local}"
export DT_STORAGE_BASE_PATH="${DT_STORAGE_BASE_PATH:-$DATA_DIR/uploads}"
export DT_STORAGE_MAX_FILE_SIZE="${DT_STORAGE_MAX_FILE_SIZE:-10485760}"      # 10 MB per file
export DT_STORAGE_MAX_USER_STORAGE="${DT_STORAGE_MAX_USER_STORAGE:-1073741824}" # 1 GB per circle

# Links in emails (password reset) point at the public URL.
if [ -n "${DT_SERVER_PUBLIC_HOST:-}" ]; then
  export DT_EMAIL_APP_HOST="${DT_EMAIL_APP_HOST:-$DT_SERVER_PUBLIC_HOST}"
fi

# Donetick reads ./config/selfhosted.yaml and writes it on first start.
cd "$DATA_DIR"
exec /donetick
