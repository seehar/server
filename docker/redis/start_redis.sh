#!/bin/bash

# 定义脚本使用的常量
REDIS_IMAGE="redis"
REDIS_CONTAINER_NAME="redis"
REDIS_CONF_URL="http://download.redis.io/redis-stable/redis.conf"
REDIS_DATA_DIR="./data"
REDIS_CONF_FILE="./redis.conf"
REDIS_PASSWORD="123456"

# 下载Redis配置文件
echo "正在下载Redis配置文件..."
if ! wget --quiet -O $REDIS_CONF_FILE $REDIS_CONF_URL; then
    echo "下载Redis配置文件失败，请检查网络连接或URL。"
    exit 1
fi

# 检查是否存在名为redis的容器，如果存在则停止并删除
if docker container ls -a | grep -qw "$REDIS_CONTAINER_NAME"; then
    echo "停止并移除已存在的$REDIS_CONTAINER_NAME容器..."
    docker container stop $REDIS_CONTAINER_NAME
    docker container rm $REDIS_CONTAINER_NAME
fi

# 检查数据目录是否存在，如果不存在则创建
if [ ! -d "$REDIS_DATA_DIR" ]; then
    echo "创建数据存储目录..."
    mkdir -p "$REDIS_DATA_DIR"
fi

# 启动Redis容器
echo "启动Redis容器..."
docker run -p 6379:6379 --name $REDIS_CONTAINER_NAME \
           -v $REDIS_DATA_DIR:/data \
           -v $REDIS_CONF_FILE:/etc/redis/redis.conf \
           -e REDIS_PASSWORD=$REDIS_PASSWORD \
           -d $REDIS_IMAGE \
           redis-server --requirepass $REDIS_PASSWORD

# 检查容器是否成功启动
if docker container ls | grep -qw "$REDIS_CONTAINER_NAME"; then
    echo "Redis容器已成功启动。"
    echo "密码: 123456"
else
    echo "Redis容器启动失败，请检查日志以获取更多信息。"
    exit 1
fi
