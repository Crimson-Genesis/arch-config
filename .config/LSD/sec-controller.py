#!/usr/bin/env python

import subprocess
import time
import faker


class Operations:
    def __init__(self, indexed=True) -> None:
        self.fake = faker.Faker()
        # self.options = "\n".join(["Brightness"])
        self._options = {
            0: "Brightness",
            -1: "Exit - asdf",
        }
        if indexed:
            self.opts = [f"{i}. {j}" for i, j in self._options.items()]
        else:
            self.opts = [f"{j}" for j in self._options.values()]

    def _selector(
        self,
        type_=str,
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
            if type_ == int:
                if result.isdecimal():
                    result = int(result)
                else:
                    result = self._selector(type_=type_, qin=qin)
                return result
            else:
                return result
        except KeyboardInterrupt:
            # exit(0)
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

    def menu(self, opts=None):
        if opts == None:
            opts = "\n".join(self.opts)
        selection = self._selector(opts=opts)
        ops = self.get_index(self.opts, selection)
        if ops == 0:
            inp = self._selector(type_=int, qin=True)
            if inp > 100:
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


if __name__ == "__main__":
    try:
        opts = Operations(indexed=False)
        opts.main()

    except KeyboardInterrupt:
        print("Good Bye...")
        exit(0)
else:
    exit(1)
