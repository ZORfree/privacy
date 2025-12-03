#!/bin/bash

# build-all.sh - 一键编译 Go 程序为多平台可执行文件

set -e  # 遇到错误立即退出

# 源文件路径
SOURCE="main/main.go"
# 输出目录
OUTPUT_DIR="dist"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 定义目标平台 (GOOS 和 GOARCH 组合)
PLATFORMS=(
    "linux/amd64"
    "linux/386"
    "linux/arm64"
    "linux/arm"
    "darwin/amd64"
    "darwin/arm64"
    "windows/amd64"
    "windows/386"
)

echo "开始编译全平台版本..."

for PLATFORM in "${PLATFORMS[@]}"; do
    IFS='/' read -r GOOS GOARCH <<< "$PLATFORM"
    OUTPUT_NAME="app"

    # Windows 平台加 .exe 后缀
    if [ "$GOOS" = "windows" ]; then
        OUTPUT_NAME="${OUTPUT_NAME}.exe"
    fi

    echo "编译: $GOOS/$GOARCH -> $OUTPUT_DIR/app_${GOOS}_${GOARCH}"
    CGO_ENABLED=0 GOOS="$GOOS" GOARCH="$GOARCH" go build -o "$OUTPUT_DIR/app_${GOOS}_${GOARCH}/${OUTPUT_NAME}" "$SOURCE"
done

echo "✅ 所有平台编译完成！输出目录: $OUTPUT_DIR"