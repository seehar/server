CONTAINER_NAME := dbhub
HOST_PORT      := $(or $(DBHUB_PORT),9800)
IMAGE          := bytebase/dbhub:latest
CONFIG_FILE    := $(CURDIR)/dbhub.toml
ENV_FILE       := $(CURDIR)/.env

ENV_FILE_ARG := $(if $(wildcard $(ENV_FILE)),--env-file $(ENV_FILE),)

.PHONY: start stop

start: $(CONFIG_FILE)
	@if docker container ls -a --format '{{.Names}}' | grep -qw $(CONTAINER_NAME); then \
		echo "停止并移除已存在的 $(CONTAINER_NAME) 容器..."; \
		docker container stop $(CONTAINER_NAME) >/dev/null; \
		docker container rm $(CONTAINER_NAME) >/dev/null; \
	fi
	@echo "拉取 DBHub 镜像..."
	docker pull $(IMAGE)
	@echo "启动 DBHub 容器, 监听端口: $(HOST_PORT)..."
	docker run -d --init \
		--name $(CONTAINER_NAME) \
		--restart unless-stopped \
		--add-host=host.docker.internal:host-gateway \
		-p $(HOST_PORT):8080 \
		-v $(CONFIG_FILE):/app/dbhub.toml:ro \
		-e DBHUB_LOG_LEVEL=info \
		$(ENV_FILE_ARG) \
		$(IMAGE) \
		--transport http \
		--port 8080 \
		--config /app/dbhub.toml
	@echo ""
	@echo "DBHub 已启动:"
	@echo "  访问地址:  http://localhost:$(HOST_PORT)"
	@echo "  MCP 端点:  http://localhost:$(HOST_PORT)/message"
	@echo "  配置文件:  $(CONFIG_FILE) (修改后自动热重载)"
	@echo "  查看日志:  docker logs -f $(CONTAINER_NAME)"
	@echo "  停止容器:  make stop"

stop:
	@if docker container ls -a --format '{{.Names}}' | grep -qw $(CONTAINER_NAME); then \
		echo "停止并移除 $(CONTAINER_NAME) 容器..."; \
		docker container stop $(CONTAINER_NAME) >/dev/null; \
		docker container rm $(CONTAINER_NAME) >/dev/null; \
		echo "$(CONTAINER_NAME) 已停止并移除."; \
	else \
		echo "$(CONTAINER_NAME) 容器不存在."; \
	fi
