@echo off
chcp 65001
call ./venv/Scripts/activate.bat
setlocal EnableDelayedExpansion
set /a count=1
set s_text=%1
set s_channelID=%3
set s_regex=%2
if "%2" == "" (
echo start scraping...
python getVideosURL.py %s_text%
echo done scraping
for /f %%i in (links.txt) do (
if !count! == 10 goto :end
yt-dlp --write-auto-sub --convert-subs=srt --sub-lang ru -f "bestvideo[height<=240][ext=mp4][fps<=60]+bestaudio[ext=m4a]/best[ext=mp4]/best" "%%i" --output "./videos/raw/1"
cd ./videos/raw/
ren 1.ru.srt 1.srt
videogrep --input "1.mp4" -s "%s_text%" -p 15 -o "../done/%s_text%_!count!.mp4"
del 1.*
cd ../../
set /a count=!count! + 1
echo !count!
)
) 
:end
pause
endlocal
