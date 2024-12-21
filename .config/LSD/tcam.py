#!/usr/bin/env python3

import sys
import inspect
import time
import threading
import itertools


def loading_animation(stop_flag):
    spinner = itertools.cycle(["⢿", "⣻", "⣽", "⣾", "⣷", "⣯", "⣟", "⡿"])
    while not stop_flag.is_set():
        sys.stdout.write("\r" + next(spinner) + " Loading")
        sys.stdout.flush()
        time.sleep(0.1)
    sys.stdout.write("\rDone.....\n")


def decor(primery_thread=loading_animation):
    def sub_thread(sub_thread):
        def wrapper(*args, **kwargs):
            stop_flag = threading.Event()
            thread = threading.Thread(target=primery_thread, args=(stop_flag,))
            thread.start()
            sub_thread(*args, **kwargs)
            stop_flag.set()
            thread.join()

        return wrapper

    return sub_thread


class Tcam:
    """
    It is a class for Handling the Terminal command flags.
    """

    def __init__(self, structure) -> None:
        """
        Constricter takes 1 arg:
            <structure>  :  It defines the structer of the Terminal command workflow.
                            Note:- only enter value if want of modify it. The values
                            in the EX are the default values.
                Ex:-
                    {
                        "<-some-flag>" : {
                            "alias" : [<str>] | None,
                            "input" : <True | False>,
                            "input_type":{              # If input is True.
                                "datatype" : <datatype instance>,
                                "description": <description of input>,
                                "parameter": <by which parameter function will thisi nput>,
                            },
                            "default_args": [<list of default args for the function>] | None,
                            "function" : <function reference>} | None,
                            "decorator_function": <function instance which will be wrapped around "function">,
                            "next": {<next flag with same structure>} | None,
                        }
                    }
        """
        self.structure: dict = structure
        self.args = sys.argv[1:]
        if self.structure.get("all"):
            self.all = self.structure.pop("all")
        else:
            self.all = None

    def run(self):
        """
        It runs the Terminal command and parces all the
        args and puts them all in the function.
        """
        config = self.run_config()
        print(config)
        for function in config["function"]:
            if config.get("decorator_function"):
                if function in config["decorator_function"]:
                    config["decorator_function"][function](function)(
                        **(config["input_args"].get(function) or {}),
                        **(config["default_args"].get(function) or {}),
                    )
                    continue
            function(
                **(config["input_args"].get(function) or {}),
                **(config["default_args"].get(function) or {}),
            )

    def run_config(self):
        """
        Config for self.run function.
        """
        config_dict = {
            "input_args": dict(),
            "default_args": dict(),
            "function": set(),
            "decorator_function": dict(),
        }
        alias = self.alias()
        current_flag = self.structure.copy()
        arg_index = 0
        function = None
        current_arg = None
        while arg_index < len(self.args):
            current_arg = self.args[arg_index]

            if current_arg in current_flag:
                current_flag = current_flag[current_arg]
            elif current_arg in alias:
                current_arg = alias[current_arg]
                current_flag = current_flag[alias[current_arg]]
            elif self.all:
                all_alias = self.alias(self.all)
                if current_arg in self.all:
                    current_flag = self.all[current_arg]
                elif current_arg in all_alias:
                    current_flag = self.all[all_alias[current_arg]]
                else:
                    self.__error(
                        ValueError,
                        message="The commands goes like:-\n"
                        + "\n".join(
                            [value for value in self.commands(self.all) if self.args]
                        ),
                    )
            else:
                self.__error(ValueError)

            # print(current_flag)
            # print("\n")
            if current_flag.get("function"):
                config_dict["function"].add(current_flag["function"])
                function = current_flag["function"]

            if current_flag.get("decorator_function"):
                config_dict["decorator_function"][function] = current_flag[
                    "decorator_function"
                ]

            if current_flag.get("input") is True:
                arg_index += 1
                if not config_dict["input_args"].get(function):
                    config_dict["input_args"][function] = {}
                config_dict["input_args"][function][
                    current_flag["input_type"]["parameter"]
                ] = self.args[arg_index]

            if current_flag.get("default_args"):
                if not config_dict["default_args"].get(function):
                    config_dict["default_args"][function] = {}
                config_dict["default_args"][function].update(
                    current_flag["default_args"]
                )

            if current_flag.get("next"):
                current_flag = current_flag["next"]
            else:
                ...
            arg_index += 1

        return config_dict

    def alias(self, structure: dict | None = None):
        """
        It return all the alias in a dict formate.
            Ex:- { <alias>:<flag> }
        """
        structure = structure if structure else self.structure
        return {
            value: key
            for key, values in structure.items()
            if values.get("alias")
            for value in values.get("alias")
        }

    def __error(self, error_type, message: str | None = None):
        errors = {
            ValueError: "The commands goes like:-\n"
            + "\n".join([value for value in self.commands() if self.args]),
        }
        raise error_type(errors[error_type] if not message else message)

    def commands(self, struc: dict | None = None):
        """
        It return all the command combination of the structure.
        """
        if struc is None:
            struc = self.structure
        result = []
        i_key = ""
        for key in struc.keys():
            i_key = key
            if struc[key].get("alias"):
                og_key = key.split(" ")
                old_key = og_key[:-1]
                og_key = og_key[-1]
                i_key = (
                    " ".join(old_key)
                    + " <"
                    + " | ".join([og_key] + struc[key]["alias"])
                    + ">"
                )
            if struc[key].get("input") is True:
                if input_type := struc[key].get("input_type"):
                    if input_type.get("description"):
                        i_key += f" <{input_type['description']}> "
                    else:
                        i_key += " <input> "
                else:
                    i_key += " <input> "
            if nx := struc[key].get("next"):
                for next_key in nx.keys():
                    result.append(
                        *self.commands(struc={i_key + next_key: nx[next_key]})
                    )
            else:
                result.append(i_key)
        return result

    def __str__(self) -> str:
        return str(self.__repr__)

    def __add__(self, other):
        f"""
        Addes the instance.structure and return new Tcam class
        with current.structure + instance.structure.
        """
        if isinstance(other, Tcam):
            return Tcam(self.structure.update(self.other.structure))  # type: ignore
        else:
            return TypeError(f"Only supports the type of " + Tcam.__name__)

    def __repr__(self) -> str:
        return f"{Tcam.__name__}({self.structure})"


# x = Tcam(struc)
# x.run()
