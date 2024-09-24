#!/bin/bash

# 检查是否已存在名为mysql的容器，如果存在则停止并删除
if docker container ls -a | grep -qw "mysql"; then
    echo "停止并移除已存在的mysql容器..."
    docker container stop mysql
    docker container rm mysql
fi

# 拉取MySQL:8的镜像（如果本地没有的话）
echo "拉取MySQL 8镜像..."
docker pull mysql:8

# 启动MySQL容器
echo "启动MySQL容器，允许远程连接..."
docker run --name mysql \
           -p 3306:3306 \
           -e MYSQL_ROOT_PASSWORD=123456 \
           -e MYSQL_DATABASE=testdb \
           -e MYSQL_USER=testuser \
           -e MYSQL_PASSWORD=123456 \
           -d mysql:8 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

echo "MySQL容器已启动，可以通过端口3306访问。"

# 提供一些基本的信息
echo "数据库设置:"
echo "数据库名: testdb"
echo "用户名: testuser"
echo "密码: 123456"
echo "注意: 请根据实际需要更改上述默认值。"
