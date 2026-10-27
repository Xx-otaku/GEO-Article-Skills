#!/bin/sh
set -eu

source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target_dir="${CODEX_HOME:-$HOME/.codex}/skills"

if [ "$#" -gt 0 ]; then
  if [ "$#" -ne 2 ] || [ "$1" != "--destination" ] || [ -z "$2" ]; then
    printf '用法：%s [--destination 技能目录]\n' "$0" >&2
    exit 2
  fi
  target_dir=$2
fi

skill_names='brand-knowledge-base brand-positioning brand-content-topics brand-content-write brand-content-audit brand-content-rewrite'
conflicts=0

for skill_name in $skill_names; do
  if [ ! -f "$source_dir/skills/$skill_name/SKILL.md" ]; then
    printf '缺少技能文件：%s\n' "$source_dir/skills/$skill_name/SKILL.md" >&2
    exit 1
  fi
  if [ -e "$target_dir/$skill_name" ] || [ -L "$target_dir/$skill_name" ]; then
    printf '已存在，未覆盖：%s\n' "$target_dir/$skill_name" >&2
    conflicts=1
  fi
done

if [ "$conflicts" -ne 0 ]; then
  printf '请先备份并处理同名目录，再重新安装；本次没有复制任何技能。\n' >&2
  exit 1
fi

mkdir -p "$target_dir"
for skill_name in $skill_names; do
  cp -R "$source_dir/skills/$skill_name" "$target_dir/$skill_name"
  printf '已安装：%s\n' "$skill_name"
done

printf '\n六个技能已安装到：%s\n' "$target_dir"
printf '在下一次 Codex 对话中使用，例如：$brand-knowledge-base\n'
