#!/usr/bin/python3.12

import itertools
import threading
import pkgutil
import time
import sys
import warnings
import keyword
import builtins
from os import system

warnings.filterwarnings("ignore")


DONE = False


def onerror(error):
    pass


def all_submodule():
    global DONE
    result = set()
    try:
        for _, name, _ in pkgutil.walk_packages(
            path=["/home/zero/anaconda3/lib/python3.12"], onerror=onerror
        ):
            result.add(name)
        for _, name, _ in pkgutil.walk_packages(onerror=onerror):
            result.add(name)
        for name in sys.modules.keys():
            result.add(name)
            if not "." in name:
                for sub_name in dir(__import__(name)):
                    result.add(f"{name}.{sub_name}")
        for name in keyword.kwlist:
            result.add(name)
        for name in dir(builtins):
            result.add(name)
    except:
        pass
    DONE = True
    return sorted(result)


def loading_animation():
    global DONE
    spinner = itertools.cycle(["⢿", "⣻", "⣽", "⣾", "⣷", "⣯", "⣟", "⡿"])
    while not DONE:
        sys.stdout.write("\r" + next(spinner) + " Loading")
        sys.stdout.flush()
        time.sleep(0.1)


def main():
    spinner_thread = threading.Thread(target=loading_animation, daemon=True)
    spinner_thread.start()
    submodules = all_submodule()
    file_path = ".modules_list.txt"
    with open(file_path, "w") as mod:
        mod.write("")
    with open(file_path, "at+") as mod:
        for name in submodules:
            mod.write(name + "\n")
    spinner_thread.join()
    # system("clear")
    sys.stdout.write("\rEverything in Data-File has been Updated.\n")
    sys.stdout.write(f"Total Number of Entries:- {len(submodules)}")


main()
