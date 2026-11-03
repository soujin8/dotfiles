#!/bin/bash
# ~/.agents/skills 配下の各スキルを ~/.claude/skills へ個別に symlink する。
# ディレクトリごと symlink すると Claude Code 専用のファイル（synced/ や .trash/）が
# ~/.agents/skills に書き込まれるため、スキル単位でリンクする。
set -euo pipefail

src="$HOME/.agents/skills"
dst="$HOME/.claude/skills"

[ -d "$src" ] || exit 0

# 旧構成（ディレクトリ全体の symlink）からの移行
if [ -L "$dst" ]; then
  rm "$dst"
fi
mkdir -p "$dst"

for dir in "$src"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  link="$dst/$name"
  target="../../.agents/skills/$name"
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$target" ] && continue
    rm "$link"
  elif [ -e "$link" ]; then
    # Claude Code 専用の実ディレクトリは上書きしない
    continue
  fi
  ln -s "$target" "$link"
done

# ~/.agents/skills 側で削除されたスキルのリンクを掃除する
for link in "$dst"/*; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in
    ../../.agents/skills/*) [ -e "$link" ] || rm "$link" ;;
  esac
done
