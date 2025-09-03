#!/usr/bin/env python

import os
import time
from pprint import pprint

file_ch_index = 1
consistency = {"valid":list(), "invalid":list()}
dirctory = "./Shadow Slave/"
for f_name in os.listdir(dirctory):
    filepath = os.path.join(dirctory, f_name)
    f_head = ...
    if os.path.isfile(filepath):
        with open(filepath, "r", encoding="utf-8") as file:
            lines = file.readlines()
            if len(lines) >= 9:
                if (lines[8].strip() == "---"):
                    consistency["invalid"].append(file_ch_index)
                    print(lines[8].strip()," ", end="")
                else:
                    consistency["valid"].append(file_ch_index)
            else:...
    file_ch_index += 1
print(consistency["invalid"])
