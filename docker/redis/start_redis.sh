wget http://download.redis.io/redis-stable/redis.conf

docker run -p 6379:6379 --name redis -v ./data:/data \
	   -v ./redis.conf:/etc/redis/redis.conf \
	   -d redis redis-server /etc/redis/redis.conf
