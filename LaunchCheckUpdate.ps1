$cmdlog = "C:\steamcmd\logs\content_log.txt"   #steamcmd log file to detec new mod updates
$date = get-date -Format FileDateTime
$modupdater = "C:\steamcmd\ModUpdater.bat" #start check new mods update
$startserver = "C:\Games\Arma3\A3Master\!StartSERVER.bat"  #start arma3 server bat with restart monitor
copy-item $cmdlog "C:\steamcmd\logs\content_log-$date.txt"
clear-content $cmdlog

# Token
$token = "TELEGRAM_TOKEN"   #your telegram bot token
# Telegram URLs
$URL_get = "https://api.telegram.org/bot$token/getUpdates"
$URL_set = "https://api.telegram.org/bot$token/sendMessage" 

function sendMessage($URL, $chat_id, $text)
{
    # создаем HashTable, можно объявлять ее и таким способом
    $ht = @{
        text = $text
        # указан способ разметки Markdown
        parse_mode = "Markdown"
        chat_id = $chat_id
    }
    # Данные нужно отправлять в формате json
    $json = $ht | ConvertTo-Json
    # Делаем через Invoke-RestMethod, но никто не запрещает сделать и через Invoke-WebRequest
    # Method Post - т.к. отправляем данные, по умолчанию Get
    Invoke-RestMethod $URL -Method Post -ContentType 'application/json; charset=utf-8' -Body $json    
}

$modupdaterresult = C:\steamcmd\CheckNewMods.ps1 -Wait -NoNewWindow -PassThru

$cmdlogcontent = Get-Content $cmdlog
if ($cmdlogcontent -match "mismatching files" -or $cmdlogcontent -match "Downloading"){
    Write-Host "====MOD UPDATE DETECTED====" -Fore DarkYellow

    $players = py C:\steamcmd\Rcon_Get-players.py
    $players = ($players | Select-String -Pattern 'players in total') -replace "^\((\d).*", '$1'
    Write-Host "Players online:"$players
    if ($players -eq 0) {
        Write-Host "Restarting server"
    }
    else {
        py C:\steamcmd\Rcon_Send-Message.py
        Start-Sleep -Seconds 600
    }
    
    Stop-Process -Name "cmd"
    Stop-Process -Name "arma3server"

    $trueupdate = C:\steamcmd\CheckNewMods.ps1  -Wait -NoNewWindow -PassThru

    New-Item "C:\Users\Администратор\Desktop\SERVER-UPDATED-$date.txt"  # create file with update date
    Start-Process C:\Games\Arma3\A3Master\!StartSERVER.bat
    sendMessage $URL_set TELEGRAMCHATID "MOD UPDATE DETECTED" ##Enter your telegram chat ID
}
else {
    Write-Host "Updates not found"
}

Write-Host ""