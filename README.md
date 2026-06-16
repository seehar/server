# server

> 服务端常用脚本

## 目录

- `docker/` — Docker 服务编排与启动脚本（MySQL / Redis 等）
- `script/` — 安装与运维脚本
- `dotfiles/` — 终端环境配置（Alacritty + tmux）
- `config/` — 通用配置示例

## Dotfiles (Alacritty + tmux)

个人终端环境配置，新机器一行命令即可复刻。

### 包含

- `dotfiles/alacritty/alacritty.toml` — Alacritty 配置（字体 Maple Mono NF、配色、键位、窗口透明度等）
- `dotfiles/tmux/tmux.conf` — tmux 配置（`C-a` 前缀、vim 风格 pane 切换、状态栏、popup 等）

### 安装

在仓库根目录执行：

```bash
# 默认：软链接到 ~/.config/alacritty/alacritty.toml 与 ~/.tmux.conf
# 之后修改 dotfiles/ 下的文件即刻生效
bash script/install_dotfiles.sh

# 可选：直接拷贝（与项目脱钩，互不影响）
bash script/install_dotfiles.sh --copy
```

目标位置已有同名文件会自动重命名为 `*.bak.<时间戳>` 备份，脚本可重复执行。

如已在 tmux 会话中，重新加载配置：

```bash
tmux source-file ~/.tmux.conf
```
