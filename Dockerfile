# syntax=docker/dockerfile:1.4

FROM alpine:latest

# 安装依赖
RUN apk --no-cache add ca-certificates gettext

WORKDIR /data
COPY server/dist/database.db .

WORKDIR /server
COPY server/dist/ .

WORKDIR /app

# 启用 TARGETPLATFORM
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# 根据 TARGETARCH 自动决定二进制路径
# 注意：TARGETARCH 对于 arm/v7 是 "arm"，arm64 是 "arm64"，amd64 是 "amd64"
COPY website/build/ /app/


# 使用条件逻辑（Dockerfile 1.4+ 支持）
RUN case "$TARGETARCH" in \
        amd64) BINARY_PATH="server/dist/app_linux_amd64/app" ;; \
        arm64) BINARY_PATH="server/dist/app_linux_arm64/app" ;; \
        arm)   BINARY_PATH="server/dist/app_linux_arm/app" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    cp "$BINARY_PATH" ./app
# 复制配置和脚本
COPY config.yaml.docker ./config.yaml.docker
COPY entrypoint.sh ./entrypoint.sh
# 设置权限
RUN chmod +x app ./entrypoint.sh
# 创建非 root 用户（可选但推荐）
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser
# 👇 关键修复：将 /app 目录所有权赋予 appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]