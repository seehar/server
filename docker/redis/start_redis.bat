@echo off
REM 下载Redis配置文件
powershell -Command "Invoke-WebRequest 'http://download.redis.io/redis-stable/redis.conf' -OutFile './redis.conf'"

REM 运行Redis容器
docker run -p 6379:6379 --name redis -v ./data:/data -v ./redis.conf:/etc/redis/redis.conf -d redis redis-server /etc/redis/redis.conf
