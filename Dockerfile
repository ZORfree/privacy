FROM alpine:latest

RUN apk --no-cache add ca-certificates gettext

WORKDIR /app

# 复制前端
COPY website/build/ /app/

# 复制后端二进制（多架构）
ARG TARGETARCH
ARG TARGETVARIANT
COPY server/dist/app_linux_${TARGETARCH}/app ./app

# 复制配置和脚本
COPY config.yaml.docker .
COPY entrypoint.sh .

RUN chmod +x entrypoint.sh app

# （可选）创建非 root 用户
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser
USER appuser

EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]