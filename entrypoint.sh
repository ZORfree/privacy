#!/bin/sh
set -e

# ===== 设置默认环境变量（如果未设置）=====
: ${DATABASE_PATH:=/data/database.db}
: ${TABLE_QQ:=true}
: ${TABLE_JD:=true}
: ${TABLE_SF:=false}
: ${TABLE_WB:=false}
: ${HTTP_HOST:=0.0.0.0}
: ${HTTP_PORT:=8080}
: ${MASK:=true}

# 可选：将端口转为整数（防止 YAML 解析问题）
# 但 envsubst 是字符串替换，YAML 中 8080 无引号即可被解析为整数

# ===== 生成 config.yaml =====
envsubst < /app/config.yaml.docker > /app/config.yaml

cd /app/ || exit 1
# ===== 启动应用 =====
exec ./app --config ./config.yaml
