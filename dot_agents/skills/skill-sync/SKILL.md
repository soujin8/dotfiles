---
name: skill-sync
description: |
  chezmoi ソース（~/.local/share/chezmoi/dot_agents/skills/）を正として、
  Agent Skill の新規作成・更新・削除を `chezmoi apply` 経由で ~/.agents/skills/ に反映し、
  さらに ~/.claude/skills/ と ~/.codex/skills/ への反映状況（symlink か実体か、
  内容が一致しているか）を確認する。実体ディレクトリのまま乖離している場合は差分を検出して
  レポートし、symlink 化やコピーなどの同期方法をユーザーに確認してから行う。
  「スキルを同期して」「新しいスキルを追加して」「スキルの乖離をチェックして」といった依頼、
  および他のスキルの新規作成・更新・削除作業が完了したタイミングで使う。
---

# Skill Sync

Claude Code と Codex CLI でスキルを共通管理するため、chezmoi ソースを正として
`~/.agents/skills/` `~/.claude/skills/` `~/.codex/skills/` の3箇所を同期させる。

**状態を仮定しない。** symlink 運用が構築済みかは変わりうるので、必ず実行時に確認する。

## 手順

### 1. 現状確認（必ず最初に実行する）

```bash
python3 -c "
import os
for p in ['~/.agents/skills','~/.claude/skills','~/.codex/skills']:
    p2 = os.path.expanduser(p)
    print(p, '->', os.path.realpath(p2), 'islink:', os.path.islink(p2))
"
```

- `~/.claude/skills` や `~/.codex/skills` が `~/.agents/skills` への symlink なら
  その系統は自動同期済み。以降の手動同期は不要。
- symlink でなく実体ディレクトリなら乖離しうる状態なので、手順4で差分確認を行う。

### 2. スキルの新規作成・更新・削除は chezmoi ソースに対して行う

- 編集対象は必ず `~/.local/share/chezmoi/dot_agents/skills/<skill-name>/SKILL.md` 等。
- `~/.claude/skills/` `~/.codex/skills/` `~/.agents/skills/` を直接編集・削除しない。
  symlink 化済みでも直接編集はソースの二重管理を招くため、常にソース側を編集する。

### 3. chezmoi apply で `~/.agents/skills/` に反映する

```bash
chezmoi diff   # まず差分を確認する
```

追加・変更のみなら `chezmoi apply` をそのまま実行する。既存スキルの削除や大幅書き換えなど
破壊的な差分が含まれる場合は、diff 内容を要約してユーザーに確認を取ってから実行する。

```bash
chezmoi apply
```

### 4. `~/.claude/skills/` `~/.codex/skills/` への反映確認

手順1の結果で分岐する。

- **symlink 済みの系統**: 手順3の apply だけで自動反映済み。何もしない。
- **実体ディレクトリのままの系統**: 乖離を検出し、レポートしてから対応をユーザーに確認する。

```bash
# ~/.agents/skills（正）と各ツール側の実体ディレクトリを比較する（.system は対象外）
diff -rq ~/.agents/skills ~/.claude/skills | grep -v '\.system'
diff -rq ~/.agents/skills ~/.codex/skills  | grep -v '\.system'
```

レポートには次を含める。
- 正（`~/.agents/skills`）にしかないスキル → 未反映
- ツール側にしかないスキル → ツール固有か削除漏れか要確認
- 両方にあるが内容が異なるスキル（`diff -rq` の "Files ... differ" 行）

レポート後、同期方法をユーザーに確認する。
- symlink 化: 実体ディレクトリを削除して `ln -s ~/.agents/skills <対象>` を作成する
  （`rm -rf` の対象と実行タイミングを事前提示する）。
- コピー同期: `rsync -a --delete ~/.agents/skills/ <対象>/` 等、削除を伴うコマンドは
  実行前に対象と影響範囲を提示する。
- **ユーザーの承認なしに symlink 化・上書き・削除を行わない。**

### 5. Codex 固有ファイルは同期対象外として保護する

`~/.codex/skills/.system/` 等 Codex 専用ファイルは chezmoi ソースにも
`~/.agents/skills/` にも存在しない前提で扱い、差分レポートや削除提案から除外する。

## エッジケース

- **chezmoi ソースと `~/.agents/skills/` が乖離している（apply 忘れ）**:
  `chezmoi diff` で未適用の差分が出る。先にそれを解消してから手順4に進む。
- **symlink が壊れている（リンク先が存在しない）**:
  `readlink` でリンク先を確認し、ユーザーに確認の上でリンクを削除し、
  正しいリンク先（`~/.agents/skills`）で張り直す。
- **一部のスキルだけ意図的にツール固有にしたい場合**:
  ディレクトリ全体の symlink 化ではなく、スキル単位のコピー同期を提案する。
