#!/usr/bin/env python

import subprocess
import time
import os
# import faker

def send_notfi(
    self,
    msg:None|str=None,
    cmd=None,
):
    if cmd:
        command = cmd.split(
            " "
        )
        subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    elif msg:
        subprocess.run(
            ["notify-send", msg],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    else:
        ...

class Operations:
    def __init__(self, indexed=True) -> None:
        # self.fake = faker.Faker()
        # self.options = "\n".join(["Brightness"])
        self.__update_env(indexed=indexed)

    def __update_env(self, indexed = False):
        self._options = {
            0: self.get_brightness(),
            1: self.get_volume(),
            -1: "Exit - asdf",
        }
        if indexed:
            self.opts = [f"{i}. {j}" for i, j in self._options.items()]
        else:
            self.opts = [f"{j}" for j in self._options.values()]

    def _selector(
        self,
        qin=False,
        opts="",
    ):
        try:
            if qin:
                result = subprocess.run(
                    ["fzf", "--wrap", "--cycle", "--ansi", "--print-query"],
                    input=opts,
                    text=True,
                    capture_output=True,
                ).stdout.strip()
            else:
                result = subprocess.run(
                    ["fzf", "--wrap", "--cycle", "--ansi"],
                    input=opts,
                    text=True,
                    capture_output=True,
                ).stdout.strip()
            return result
        except KeyboardInterrupt:
            ...

    def send_notfi(
        self,
        msg:None|str=None,
        cmd=None,
    ):
        if cmd:
            command = cmd.split(
                " "
            )
            subprocess.run(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
        elif msg:
            subprocess.run(
                ["notify-send", msg],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
        else:
            ...

    def get_volume(self,):
        result = subprocess.run(
            ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
            capture_output=True,
            text=True,
        ).stdout.strip()
        # example output: "Volume: 0.45"
        vol = int(float(result.split()[1]) * 100)
        is_mut = " [MUTED]" if self.is_muted() == "yes" else ""
        return f"Volume - {vol}" + is_mut

    def is_muted(self,):
        result = subprocess.run(
            ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
            capture_output=True,
            text=True,
        ).stdout
        return "yes" if "MUTED" in result else "no"

    def get_brightness(self,):
        current = subprocess.run(
            ["brightnessctl", "g"],
            capture_output=True,
            text=True,
        ).stdout.strip()

        maximum = subprocess.run(
            ["brightnessctl", "m"],
            capture_output=True,
            text=True,
        ).stdout.strip()
        return f"Brightness - {int((int(current) / int(maximum)) * 100)}"

    def get_int(self):
        rows, cols = os.get_terminal_size()
        print("\n" * (rows - 2))
        j = input(":- ")
        os.system("clear");
        if j.isdecimal():
            return int(j)
        else:
            return None

    def menu(self, opts=None):
        if opts == None:
            opts = "\n".join(self.opts)
        selection = self._selector(opts=opts)
        ops = self.get_index(self.opts, selection)
        if ops == 0:
            inp = self.get_int()
            if inp == None:
                return;
            elif inp > 100:
                inp = 100
            elif inp < 0:
                inp = 0

            brightness = (inp / 100) * 96000
            subprocess.run(
                ["brightnessctl", "set", f"{brightness}"],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            cmd = f"notify-send -i display-brightness -t 1000 -r 1001 -u normal ☀️ {inp}% -h int:value:{inp}"
            self.send_notfi(cmd=cmd)

        elif ops == -1:
            exit(0);
        elif ops == 1:
            inp = self.get_int()
            if inp == None:
                return;
            elif inp > 100:
                inp = 100
            elif inp < 0:
                inp = 0
            vol = (inp/100)*2
            subprocess.run(["wpctl","set-volume","@DEFAULT_AUDIO_SINK@", f"{vol}"])
            self.send_notfi(cmd=f"notify-send -i audio-volume-medium -t 1000 -r 1001 -u normal 🔊 {inp*2}% -h int:value:{inp*2}")
        else:
            ...

    def get_index(self, lis: list, item):
        if item == "-1. Exit - asdf" or item == "Exit - asdf":
            return -1

        index = None
        try:
            index =  lis.index(item)
        except:
            ...
        return index

    def main(self):
        while True:
            self.menu()
            self.__update_env()

if __name__ == "__main__":
    try:
        opts = Operations(indexed=False)
        opts.main()

    except KeyboardInterrupt as e:
        print("Good Bye...")
        send_notfi(e);
        exit(0)
    except Exception as e:
        send_notfi(e);
        exit(1)
else:
    exit(1)
