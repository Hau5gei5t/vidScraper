import re
from selenium import webdriver
import sys


from selenium.webdriver.common.by import By

sys_input = sys.argv[1:]


options = webdriver.FirefoxOptions()
options.add_argument("-private-window")
options.add_argument("-headless")
wd = webdriver.Firefox(options=options)


links = []

print("-"*20)
if (len(sys_input) == 1):
    search_text = '"'+sys_input[0]+'"'
    url = f"https://filmot.com/search/{search_text}/1?channelID=&gridView=1"
    print("prepare to scrap...")
else:
    channel_id = sys_input[1]
    search_text = '"'+sys_input[0]+'"'
    url = f"https://filmot.com/search/{search_text}/1?channelID={channel_id}&gridView=1"
wd.get(url)
wd.implicitly_wait(10)
videos = wd.find_elements(By.CSS_SELECTOR, ".col-2.col-screen")
if not videos:
    print("Videos not found")
    wd.quit()
    exit(0)
for video in videos:
    raw_link = video.find_elements(By.TAG_NAME, "a")[1].get_attribute("href")
    link = re.sub(r"&.*$", "", raw_link)
    print("links.txt <-- ", link)
    links.append(link)
links = list(set(links))
with open("links.txt", "w") as file:
    print(*links, file=file, sep="\n")

print("-"*20)
wd.quit()
