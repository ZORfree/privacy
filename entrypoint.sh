#!/bin/sh
set -e

# ===== 设置默认环境变量（如果未设置）=====
export DATABASE_PATH="${DATABASE_PATH:-/data/database.db}"
export TABLE_QQ="${TABLE_QQ:-true}"
export TABLE_JD="${TABLE_JD:-true}"
export TABLE_SF="${TABLE_SF:-false}"
export TABLE_WB="${TABLE_WB:-false}"
export HTTP_HOST="${HTTP_HOST:-0.0.0.0}"
export HTTP_PORT="${HTTP_PORT:-8080}"
export MASK="${MASK:-true}"

# 可选：将端口转为整数（防止 YAML 解析问题）
# 但 envsubst 是字符串替换，YAML 中 8080 无引号即可被解析为整数

# ===== 生成 config.yaml =====
envsubst < /app/config.yaml.docker > /app/config.yaml

cd /app/ || exit 1
# ===== 启动应用 =====
exec ./app --config ./config.yaml
