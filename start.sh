#!/bin/bash

read -r -p "Введите фразу для поиска в видео: " searchraw
read -r -p "Введите ID канала: " channelID
read -r -p "введите регулярное выражение для поиска: " search
source /home/hau5ge1st/projects/VidScraper/deps/bin/activate
python3.10 getVideosURL.py $searchraw $channelID
file="/home/hau5ge1st/projects/VidScraper/links.txt"
IFS=$'\n'
for link in $(cat $file)
do
    python3.10 yt-dlp --write-auto-sub --convert-subs=srt --sub-lang ru -f "bestvideo[height<=1080][ext=mp4][fps<=60]+bestaudio[ext=m4a]/best[ext=mp4]/best" "$link" --output "./videos/raw/1"
    mv ./videos/raw/1.ru.srt ./videos/raw/1.srt
    videogrep --input "/home/hau5ge1st/projects/VidScraper/videos/raw/1.mp4" -s "$search" -s "$searchraw" -p 15 -o "./videos/done/supercut.mp4"
    mv ./videos/done/supercut.mp4 "./videos/done/file-$(date +%Y-%m-%d:%k:%M:%S).mp4"
    rm "./videos/raw/1.mp4"
    rm "./videos/raw/1.srt"
done
exit 0