#!/usr/bin/env python

import subprocess

def get_volume():
    result = subprocess.run(
        ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
        capture_output=True,
        text=True,
    ).stdout.strip()
    # example output: "Volume: 0.45"
    return int(float(result.split()[1]) * 100)

def is_muted():
    result = subprocess.run(
        ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
        capture_output=True,
        text=True,
    ).stdout
    return "yes" if "MUTED" in result else "no"

def get_brightness():
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

    return int((int(current) / int(maximum)) * 100)

def main():
    print(get_brightness())
    print(is_muted())
    print(get_volume())

if __name__ == "__main__":
    main()
