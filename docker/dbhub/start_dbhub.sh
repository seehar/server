#!/bin/bash

# DBHub Docker 启动脚本
# 参考: https://dbhub.ai/installation#global-installation
#
# 使用方式:
#   1. cp dbhub.toml.example dbhub.toml  并填写真实连接信息(dbhub.toml 已被 gitignore)
#   2. cp .env.example .env              并填写数据库密码(dbhub.toml 中 ${VAR} 会被替换)
#   3. 执行 ./start_dbhub.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/dbhub.toml"
ENV_FILE="${SCRIPT_DIR}/.env"
CONTAINER_NAME="dbhub"
HOST_PORT="${DBHUB_PORT:-9800}"
IMAGE="bytebase/dbhub:latest"

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "错误: 配置文件不存在: ${CONFIG_FILE}"
    echo "请先执行: cp dbhub.toml.example dbhub.toml 并填写真实连接信息"
    exit 1
fi

if docker container ls -a --format '{{.Names}}' | grep -qw "${CONTAINER_NAME}"; then
    echo "停止并移除已存在的 ${CONTAINER_NAME} 容器..."
    docker container stop "${CONTAINER_NAME}" >/dev/null
    docker container rm "${CONTAINER_NAME}" >/dev/null
fi

echo "拉取 DBHub 镜像..."
docker pull "${IMAGE}"

ENV_FILE_ARG=()
if [ -f "${ENV_FILE}" ]; then
    echo "加载环境变量文件: ${ENV_FILE}"
    ENV_FILE_ARG=(--env-file "${ENV_FILE}")
fi

echo "启动 DBHub 容器, 监听端口: ${HOST_PORT}..."
docker run -d --init \
    --name "${CONTAINER_NAME}" \
    --restart unless-stopped \
    --add-host=host.docker.internal:host-gateway \
    -p "${HOST_PORT}:8080" \
    -v "${CONFIG_FILE}:/app/dbhub.toml:ro" \
    -e DBHUB_LOG_LEVEL=info \
    "${ENV_FILE_ARG[@]}" \
    "${IMAGE}" \
    --transport http \
    --port 8080 \
    --config /app/dbhub.toml

echo ""
echo "DBHub 已启动:"
echo "  访问地址:  http://localhost:${HOST_PORT}"
echo "  MCP 端点:  http://localhost:${HOST_PORT}/message"
echo "  配置文件:  ${CONFIG_FILE} (修改后自动热重载)"
echo "  查看日志:  docker logs -f ${CONTAINER_NAME}"
echo "  停止容器:  docker stop ${CONTAINER_NAME}"
