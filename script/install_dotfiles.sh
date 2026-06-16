#!/usr/bin/env bash
# 一键安装 Alacritty + tmux 配置
# 用法:
#   bash script/install_dotfiles.sh         # 默认创建软链接（改项目里的文件即刻生效）
#   bash script/install_dotfiles.sh --copy  # 直接拷贝文件（与项目脱钩）
set -euo pipefail

MODE="link"
if [[ "${1:-}" == "--copy" ]]; then
  MODE="copy"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_ALACRITTY="${REPO_DIR}/dotfiles/alacritty/alacritty.toml"
SRC_TMUX="${REPO_DIR}/dotfiles/tmux/tmux.conf"
DST_ALACRITTY="${HOME}/.config/alacritty/alacritty.toml"
DST_TMUX="${HOME}/.tmux.conf"
STAMP="$(date +%Y%m%d%H%M%S)"

[[ -f "${SRC_ALACRITTY}" ]] || { echo "缺少源文件: ${SRC_ALACRITTY}"; exit 1; }
[[ -f "${SRC_TMUX}" ]]     || { echo "缺少源文件: ${SRC_TMUX}"; exit 1; }

install_one() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "${dst}")"
  if [[ -e "${dst}" || -L "${dst}" ]]; then
    local bak="${dst}.bak.${STAMP}"
    echo "备份已有配置: ${dst} -> ${bak}"
    mv "${dst}" "${bak}"
  fi
  if [[ "${MODE}" == "link" ]]; then
    ln -s "${src}" "${dst}"
    echo "已链接: ${dst} -> ${src}"
  else
    cp "${src}" "${dst}"
    echo "已拷贝: ${src} -> ${dst}"
  fi
}

install_one "${SRC_ALACRITTY}" "${DST_ALACRITTY}"
install_one "${SRC_TMUX}"      "${DST_TMUX}"

echo
echo "完成 (mode=${MODE})。如已在 tmux 会话内，可执行: tmux source-file ~/.tmux.conf"
