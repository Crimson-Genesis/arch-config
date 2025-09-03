#!/usr/bin/env python

import urllib.parse
import requests
from bs4 import BeautifulSoup
import time
import os

try:
    WAIT_TIME = 5
    headers = {
        "User-Agent": "Mozilla/5.0"
    }

    chapter_list_url = "https://berns0.pythonanywhere.com/novels_chapters?n="
    read_url = "https://berns0.pythonanywhere.com/read?n="

    novel = input("Enter a novel name :- ")
    novel_name = urllib.parse.quote(novel) + "-chapters"
    novel_chapters_list_url = chapter_list_url + novel_name

    def get_chapter_url(chapter_number):
        return read_url + novel_name + f"&c={chapter_number}"

    def file_consistency(path_):
        dirctory = f"./{path_}/"
        for f_name in os.listdir(dirctory):
            filepath = os.path.join(dirctory, f_name)
            if os.path.isfile(filepath):
                with open(filepath, "r", encoding="utf-8") as file:
                    lines = file.readlines()
                    if len(lines) >= 9:  # check if file has at least 9 lines
                        if (lines[8].strip() == "---"):
                            ...
                    else:
                        print(f"{file.name} -> (less than 9 lines)")


    # get total chapters
    response = requests.get(novel_chapters_list_url, headers=headers)
    soup = BeautifulSoup(response.text, "lxml")
    chapters = max([
        int(a.get_text(strip=True).split(" ")[1])
        for a in soup.find_all("a", class_="chapter-card")
    ])

    from selenium import webdriver
    from selenium.webdriver.chrome.service import Service
    from selenium.webdriver.chrome.options import Options

    options = Options()
    options.add_argument("--headless=new")
    options.binary_location = "/usr/bin/chromium"   # path to chromium

    service = Service("/usr/bin/chromedriver")      # path to chromedriver
    driver = webdriver.Chrome(service=service, options=options)

    os.system(f"mkdir -p '{novel}'")
    if os.path.exists(f"./{novel}/log.txt"):
        with open(f"./{novel}/log.txt", "r") as log_file:
            last_chapter = int(log_file.read())
        os.system(f"rm ./'{novel}'/chapter_{last_chapter}.md")
        print(f"Total Chapter to Download {last_chapter} - {chapters}")
    else:
        last_chapter = 0
        print(f"Total Chapter to Download 1 - {chapters}")

    print("Starting Download in ",end="", flush=True)
    for t in range(3,0,-1):
        print(f"{t}s...", end="", flush=True)
        time.sleep(1)

    consistency_check_started = False
    completed = False
    consistency = {"valid":list(), "invalid":list()}

    while not completed:
        for i in consistency["invalid"] if consistency_check_started else range(last_chapter if last_chapter else 1, chapters):
            os.system("clear")
            print(f"Downloading Chapter - {i} in ",end="",flush=True)
            driver.get(get_chapter_url(i))
            for t in range(WAIT_TIME,0,-1):
                print(f"...{t}s", end="", flush=True)
                time.sleep(1)
            soup = BeautifulSoup(driver.page_source, "html.parser")
            paras = [p.get_text(" ", strip=True) for p in soup.select("#textContainer p.tts-paragraph")]
            with open(f"./{novel}/chapter_{i}.md","a") as ch_file:
                ch_file.write(f"\n# Chapter {i}\n")
                ch_file.write("\n\n---\n\n")
                ch_file.write("\n".join(paras))
                ch_file.write("\n\n---\n\n")
            print(f"\nChapter - {i} Downloaded and saved at ./'{novel}'/chapter_{i}.md")
            if not consistency_check_started:
                with open(f"./{novel}/log.txt","w") as log_file:
                    log_file.write(str(i))

            print("Next Chapter - ", end="", flush=True)
            for t in range(WAIT_TIME-2,0,-1):
                print(f"...{t}s", end="", flush=True)
                time.sleep(1)

        file_ch_index = 1
        dirctory = f"./{novel}/"
        consistency = {"valid":list(), "invalid":list()}
        for f_name in os.listdir(dirctory):
            filepath = os.path.join(dirctory, f_name)
            f_head = ...
            if os.path.isfile(filepath):
                with open(filepath, "r", encoding="utf-8") as file:
                    lines = file.readlines()
                    if len(lines) >= 9:
                        if (lines[8].strip() == "---"):
                            consistency["invalid"].append(file_ch_index)
                            print(filepath)
                        else:
                            consistency["valid"].append(file_ch_index)
                    else:...
            file_ch_index += 1
        consistency_check_started = True

        if len(consistency["invalid"]) == 0:
            completed = True
        with open(f"./{novel}/log.txt", "a") as file:
            file.write("consistency_check_started = True")
        def delete_invalid_ch():
            for ch_num in consistency["invalid"]:
                file_ch_path = f"./{novel}/chapter_{ch_num}.md"
                os.system(f"rm {file_ch_path}")

        delete_invalid_ch()

    driver.quit()

except KeyboardInterrupt:
    os.system("clear")
    print("Good Bye 😄")
    exit(0)
