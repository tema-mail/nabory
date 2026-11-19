#!/bin/bash
# Установка набора «Переезд из толстого чата» для Claude Code и Codex.
# Запуск: curl -fsSL https://tema-mail.github.io/nabory/pereezd/ustanovit.sh | bash
# Что делает: качает архив набора, кладёт скиллы в ~/.claude/skills и ~/.codex/skills, агентов в ~/.claude/agents
# и ~/.codex/agents (.toml), хуки в ~/.claude/hooks с записью в ~/.claude/settings.json, скрипты в ~/.claude/shablony.
# Всё, что заменяется, сначала копируется в ~/.claude/nabory-bekap/<дата>/. Повторный запуск ничего не дублирует.
set -euo pipefail
BASE="https://tema-mail.github.io/nabory/pereezd"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
if [ -f "${NABOR_ARHIV:-}" ]; then cp "$NABOR_ARHIV" "$T/n.tgz"; else curl -fsSL "$BASE/nabor.tar.gz" -o "$T/n.tgz"; fi
tar -xzf "$T/n.tgz" -C "$T"
python3 - "$T/nabor" <<'PY'
import json, os, shutil, sys, time
from pathlib import Path
src = Path(sys.argv[1]); H = Path.home(); C = H / '.claude'; X = H / '.codex'
meta = json.loads((src / 'nabor.json').read_text())
bek = C / 'nabory-bekap' / time.strftime('%Y-%m-%d-%H%M%S')
sdelano = []
def bekap(p):
    if p.exists():
        d = bek / p.relative_to(H); d.parent.mkdir(parents=True, exist_ok=True)
        (shutil.copytree if p.is_dir() else shutil.copy2)(p, d)
def polozhit(a, b):
    bekap(b)
    if b.is_dir(): shutil.rmtree(b)
    b.parent.mkdir(parents=True, exist_ok=True)
    (shutil.copytree if a.is_dir() else shutil.copy2)(a, b)
for d in sorted((src / 'skills').glob('*')) if (src / 'skills').exists() else []:
    polozhit(d, C / 'skills' / d.name); sdelano.append(f'Claude Code: скилл {d.name}')
    if X.exists(): polozhit(d, X / 'skills' / d.name); sdelano.append(f'Codex: скилл {d.name}')
for f in sorted((src / 'agents').glob('*.md')) if (src / 'agents').exists() else []:
    polozhit(f, C / 'agents' / f.name); sdelano.append(f'Claude Code: агент {f.stem}')
    if X.exists():
        t = f.read_text(encoding='utf-8'); fm, body = {}, t
        if t.startswith('---'):
            _, head, body = t.split('---', 2)
            for line in head.splitlines():
                if ':' in line and not line.startswith(' '):
                    k, v = line.split(':', 1); fm[k.strip()] = v.strip().strip('"')
        toml = (f'# Из набора «{meta["nazvanie"]}» (агент Claude Code {f.name})\n'
                f'name = {json.dumps(fm.get("name", f.stem), ensure_ascii=False)}\n'
                f'description = {json.dumps(fm.get("description", ""), ensure_ascii=False)}\n'
                "developer_instructions = '''\n" + body.strip().replace("'''", "' ' '") + "\n'''\n")
        p = X / 'agents' / (f.stem + '.toml'); bekap(p); p.parent.mkdir(parents=True, exist_ok=True); p.write_text(toml, encoding='utf-8')
        sdelano.append(f'Codex: агент {f.stem}')
for f in sorted((src / 'shablony').glob('*')) if (src / 'shablony').exists() else []:
    polozhit(f, C / 'shablony' / f.name); os.chmod(C / 'shablony' / f.name, 0o755)
if meta.get('hooks'):
    for f in sorted((src / 'hooks').glob('*')):
        polozhit(f, C / 'hooks' / f.name); os.chmod(C / 'hooks' / f.name, 0o755)
    st = C / 'settings.json'; d = {}
    if st.exists(): bekap(st); d = json.loads(st.read_text() or '{}')
    for h in meta['hooks']:
        spisok = d.setdefault('hooks', {}).setdefault(h['event'], [])
        if h['file'] in json.dumps(spisok): continue
        spisok.append({'hooks': [{'type': 'command', 'command': f'python3 "$HOME/.claude/hooks/{h["file"]}"', 'timeout': 5}]})
        sdelano.append(f'Claude Code: хук {h["file"]} ({h["event"]})')
    st.parent.mkdir(parents=True, exist_ok=True); st.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print(f'Установлен набор «{meta["nazvanie"]}»:')
for s in sdelano: print('  –', s)
if not X.exists(): print('  (Codex на этом компьютере не найден – поставлено только в Claude Code)')
if bek.exists(): print(f'Прежние версии сохранены: {bek}')
print('Перезапустите Claude Code и Codex или откройте новый чат – тогда новое заработает.')
PY
