# Переезд из толстого чата

**Что это:** скилл для Claude Code, который не даёт чату разрастись до зависания. Чат сам предупреждает, что пора переезжать, по одному слову собирает выжимку и даёт строку для нового чата. Старый чат после этого сам переименовывается в «-».

<!-- KNOPKA -->
<div class="ust">
<p class="ust-h">Установить одной кнопкой</p>
<button class="ust-b main" type="button" data-copy="Установи набор «Переезд из толстого чата»: выполни в терминале команду
curl -fsSL https://tema-mail.github.io/nabory/pereezd/ustanovit.sh | bash
и коротко скажи, что установилось. Сеть нужна.">Скопировать для Claude Code или Codex</button>
<p class="ust-p">Нажмите, вставьте в чат Claude Code или Codex и отправьте – он сам всё установит. Потом откройте новый чат.</p>
<button class="ust-b ust-b2" type="button" data-copy="curl -fsSL https://tema-mail.github.io/nabory/pereezd/ustanovit.sh | bash">Скопировать команду для Терминала</button>
<p class="ust-p"><a href="nabor.tar.gz">Скачать архив</a> · <a href="ustanovit.sh">Что делает установщик</a></p>
</div>
<!-- главная кнопка – класс main: тёмная тема artefakt.py красит все кнопки с !important, кроме button.main -->
<style>.ust{border:1px solid var(--ln);background:var(--card);border-radius:14px;padding:18px 20px;margin:20px 0}.ust-h{font-weight:600;margin:0 0 12px}.ust-b{display:block;width:100%;padding:14px 16px;border:0;border-radius:10px;background:#3b6fe0;color:#fff;font-family:inherit;font-size:16px;font-weight:600;line-height:1.2;cursor:pointer}.ust-b:hover{background:#2f5fcc}.ust-b2{background:transparent;color:var(--tx);border:1px solid var(--ln);margin-top:14px}.ust-p{color:var(--mut);font-size:14px;margin:8px 0 0}</style>
<script>document.querySelectorAll('[data-copy]').forEach(function(b){b.addEventListener('click',function(){var t=b.getAttribute('data-copy'),o=b.textContent,ok=function(){b.textContent='Скопировано ✓';setTimeout(function(){b.textContent=o},2000)};if(navigator.clipboard&&window.isSecureContext){navigator.clipboard.writeText(t).then(ok,function(){fb(t);ok()})}else{fb(t);ok()}})});function fb(t){var a=document.createElement('textarea');a.value=t;document.body.appendChild(a);a.select();try{document.execCommand('copy')}catch(e){}a.remove()}</script>
<!-- /KNOPKA -->

## Зачем

Чат больше 300 тыс. токенов тормозит. После долгого простоя он может вообще зависнуть: каждое сообщение заново прогоняет весь контекст (надпись «Idle … re-cache about 621k tokens»). Переезд в новый чат решает это за 2 минуты, и работа не теряется.

## Как пользоваться

1. Пришло «⚠️ Чат разжирел» или чат тормозит – напишите в нём одно слово: **переезд**.
2. Чат запишет выжимку и даст строку вида «Продолжаем …: прочитай ~/.claude/vyzhimki/…». Скопируйте её.
3. Откройте новый чат и вставьте строку. Новый чат продолжит с того же места, а старый станет «-».

## Что ставится

- Скилл `pereezd` – в Claude Code и, если он есть, в Codex.
- Предупреждение о толстом чате на 300, 400, 500 тыс. токенов и хук переезда – в Claude Code.
- Прежние файлы и настройки сохраняются в `~/.claude/nabory-bekap/`. Повторная установка ничего не дублирует.
