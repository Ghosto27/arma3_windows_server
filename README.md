# arma3_windows_server
Arma 3 server restart + mods update + rcon

PowerShell + python + telegram alert

Check new mods version. Add LunchCheck.bat to windows server shedule each 15-30 minutes.

Еднственный способ отследить обновление мода, которое я нашёл, через лог файл steamcmd steamcmd\logs\content_log.txt . При появлении новой версии мода, появятся такие слова, как "mismatching files" и "Downloading"

При появлении новой версии мода, происходит проверка через RCON количества игроков на сервере. 
Если 0, то сервер выключается сразу, если на сервере есть игроки, то отправка сообщения на сервер через RCON и ожидание 10 минут (600 секунд).
Затем заново проходит проверка на новые моды, загрузка и перенос новых ключей .bikey. Потом старт сервера.


rcon for python: https://github.com/conqp/rcon


#USAGE
Rcon_Get-players.py & Rcon_Send-Message.py
Измените 2307 и YOUR_RCON_PASS на свой rcon порт и пароль в файлах 

CheckNewMods.ps1
измените пути
измените YOURSTEAMLOGIN и YOURSTEAMPASS на ваши steam логин и пароль
добавите id ваших модов для проверки
(PS крупные моды, т.к. RHS могут загружаться некорректно, и в итоге не перенестись в нужную папку, если мод обновляется редко лучше не указывать его в файле и скопировать на сервер в ручную)

LunchCheck.bat
изменить путь до bat файла запуска вашего сервера

!StartSERVER.bat
изменить пути и параметры запуска сервера

LaunchCheckUpdate.ps1
изменить пути
ввести ваш TELEGRAM_TOKEN
