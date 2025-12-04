# Dockerfile
FROM alpine:latest

# 安装依赖
RUN apk --no-cache add ca-certificates gettext

WORKDIR /data
COPY server/dist/database.db .

WORKDIR /app


# 接收外部传入的架构目录名（如 amd64, arm64, arm）
ARG TARGET_ARCH_DIR

# 复制前端
COPY website/build/ /app/


# 复制对应架构的二进制
COPY server/dist/app_linux_${TARGET_ARCH_DIR}/app ./app

# 复制配置和脚本
COPY config.yaml.docker ./config.yaml.docker
COPY entrypoint.sh ./entrypoint.sh

# 设置权限
RUN chmod +x app ./entrypoint.sh

# 创建非 root 用户（可选但推荐）
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser
USER appuser

EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]