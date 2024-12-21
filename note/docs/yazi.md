# Yazi Keyboard Shortcuts Quick Reference

**Yazi** is an efficient, user-friendly, and customizable terminal file manager written in Rust, featuring non-blocking asynchronous input/output (I/O). The name "Yazi" means "duck."

---

## Default Keyboard Shortcuts (keymap.toml)

### File Operations
| Task                                      | Shortcut(s)        | Notes                                                    |
|-------------------------------------------|--------------------|----------------------------------------------------------|
| Cancel Copy/Cut File(s)                   | X, Y               |                                                          |
| Change Directory with zoxide             | z                  |                                                          |
| Change Directory/Reveal File with fzf    | Z                  |                                                          |
| Copy Directory Path                      | c + d              |                                                          |
| Copy File Path                           | c + c              |                                                          |
| Copy Filename                            | c + f              |                                                          |
| Copy Filename Without Extension          | c + n              |                                                          |
| Copy Selected File(s)                    | y                  |                                                          |
| Create File/Directory                    | a                  | End with a `/` (slash) for directories.                 |
| Cut Selected File(s)                     | x                  |                                                          |
| Delete Selected File(s) (trash)          | d                  |                                                          |
| Delete Selected File(s) Permanently      | D                  |                                                          |
| Open Selected File(s)                    | Enter, o           |                                                          |
| Open Selected File(s) Interactively      | Ctrl + Enter, O, Shift + Enter | Some terminals don't support it yet.            |
| Paste File(s)                            | p, P               | Use `P` to overwrite existing file(s) in the destination.|
| Rename Selected File(s)                  | r                  |                                                          |
| Run a Shell Command                      | ;, :               | `:` blocks until the command finishes.                  |
| Symlink Absolute Path Copied File(s)     | -                  |                                                          |
| Symlink Hardlink Copied File(s)          | Ctrl + -           |                                                          |
| Symlink Relative Path Copied File(s)     | _                  |                                                          |
| Toggle Hidden File(s) Visibility         | .                  |                                                          |

---

### Find Files
| Task                            | Shortcut(s)  | Notes                                |
|---------------------------------|--------------|--------------------------------------|
| Cancel Ongoing Search           | Ctrl + s     |                                      |
| Filter File(s)                  | f            |                                      |
| Find Next File                  | /            |                                      |
| Find Previous File              | ?            |                                      |
| Next Found Item                 | n            |                                      |
| Previously Found Item           | N            |                                      |
| Search File(s) By Content       | S            | Uses `ripgrep`.                     |
| Search File(s) By Name          | s            | Uses `fd`.                          |

---

### Miscellaneous
| Task                       | Shortcut(s) | Notes                                    |
|----------------------------|-------------|------------------------------------------|
| Help                       | ~, F1       | Display help screen.                    |
| Quit                       | q           | Quit Yazi application.                  |
| Quit Without Writing CWD File | Q       | Quit Yazi without saving current directory.|
| Suspend Process            | Ctrl + z    |                                          |

---

### Navigation
| Task                                | Shortcut(s)         | Notes                                      |
|-------------------------------------|---------------------|--------------------------------------------|
| Back Parent Directory               | ←, h, H             |                                            |
| Change Directory Config             | g + c               | Change to the config directory (`~/.config`).|
| Change Directory Downloads          | g + d               | Change to the downloads directory (`~/Downloads`).|
| Change Directory Home               | g + h               | Change to the home directory (`~/`).       |
| Change Directory Interactively      | g + Spacebar        | Enter a specific directory path.           |
| Enter Directory Highlighted         | →, l                |                                            |
| Forward Next Directory              | L                   |                                            |
| Move Cursor Bottom                  | G                   |                                            |
| Move Cursor Down                    | ↓, j                |                                            |
| Move Cursor Down Half Page          | Ctrl + d, Shift + Page Down |                                   |
| Move Cursor Down One-Page           | Ctrl + f, Page Down |                                            |
| Move Cursor Top                     | g + g               |                                            |
| Move Cursor Up                      | ↑, k                |                                            |
| Move Cursor Up Half Page            | Ctrl + u, Shift + Page Up |                                   |
| Move Cursor Up One-Page             | Ctrl + b, Page Up   |                                            |
| Move Down 5 Units (preview)         | J                   |                                            |
| Move Up 5 Units (preview)           | K                   |                                            |

---

### Selection
| Task                        | Shortcut(s)  | Notes                                    |
|-----------------------------|--------------|------------------------------------------|
| Cancel Selection            | Ctrl + [, Ctrl + c, Esc |                          |
| Select All Files            | Ctrl + a     |                                          |
| Select All Files Inverse    | Ctrl + r     |                                          |
| Submit Selection            | Enter        |                                          |
| Toggle Selection            | Spacebar     | Toggles the selection of highlighted file or directory. |
| Visual Mode Off             | V            | Turns off selection mode.               |
| Visual Mode On              | v            | Enables selection mode.                 |

---

### Sort View
| Task                          | Shortcut(s)  | Notes                                    |
|-------------------------------|--------------|------------------------------------------|
| Sort Alphabetically           | , + A        |                                          |
| Sort By Creation Time         | , + c        |                                          |
| Sort By Creation Time Reverse | , + C        |                                          |
| Sort By File Extension        | , + e        |                                          |
| Sort By File Extension Reverse| , + E        |                                          |
| Sort By Modified Time         | , + m        |                                          |
| Sort By Modified Time Reverse | , + M        |                                          |
| Sort By Size                  | , + s        |                                          |
| Sort Naturally                | , + n        |                                          |
| Sort Naturally Reverse        | , + N        |                                          |
| Sort Randomly                 | , + r        |                                          |

---

### Tab Management
| Task                           | Shortcut(s) | Notes                                    |
|--------------------------------|-------------|------------------------------------------|
| New Tab                        | t           | Creates a new tab using the current directory. |
| Switch Tab                     | 1 to 9      | Switches to the desired tab.            |
| Switch Previous Tab            | [           |                                          |
| Switch Next Tab                | ]           |                                          |
| Swap Current Tab with Previous Tab | {       |                                          |
| Swap Current Tab with Next Tab | }           |                                          |
| Close Current Tab              | Ctrl + c    | Closes the tab or quits the application if only one tab exists. |

---

### Task Manager
| Task                  | Shortcut(s)        | Notes                                    |
|-----------------------|--------------------|------------------------------------------|
| Cancel Task           | x                  |                                          |
| Close Window          | Ctrl + [, Ctrl + c, Esc, w |                                |
| Inspect Task          | Enter              |                                          |
| Move Cursor Down      | ↓, j               |                                          |
| Move Cursor Up        | ↑, k               |                                          |
| Show Task Manager     | w                  | Displays a list of active tasks.        |

---

## Notable Directories & Files
| Path                          | Description                                 |
|-------------------------------|---------------------------------------------|
| `~/.config/yazi`              | Yazi user configuration files.             |
| `~/.config/yazi/flavors/`     | Directory containing pre-made Yazi themes. |
| `~/.config/yazi/keymap.toml`  | Keybindings/keyboard shortcuts file.       |
| `~/.config/yazi/plugins/`     | Directory for Lua plugins.                 |
| `~/.config/yazi/theme.toml`   | Theme (color scheme) configuration file.   |
| `~/.config/yazi/yazi.toml`    | General configuration file.                |

---

## External Links
- [Yazi Project](https://github.com/sxyazi/yazi)
- [Yazi Documentation](https://yazi.rs/docs)
- [Yazi Documentation Keybindings](https://yazi.rs/docs/keybindings)
- [Yazi Keybinding Defaults (keymap.toml)](https://yazi.rs/docs/keymap.toml)

---


