The `tee` command in Unix-like operating systems reads from standard input and writes the output to both standard output (the terminal) and one or more files. It is useful when you want to both view and save the output of a command at the same time.

Here's the basic syntax of the `tee` command:

```bash
command | tee [options] file(s)
```

- `command`: Any command whose output you want to capture and display.
- `tee`: The command that captures the output.
- `file(s)`: The file(s) where the output will be saved. You can specify one or more files.

### Common options:
- `-a` (append): Append to the file(s) rather than overwriting them.
- `-i` (ignore interrupt signals): Useful if you want `tee` to continue writing even if you interrupt the command.

### Example:

```bash
echo "Hello, World!" | tee output.txt
```

This will:
- Display `Hello, World!` in the terminal.
- Save the same output to a file called `output.txt`.

### Example with append:

```bash
echo "Another line" | tee -a output.txt
```

This will append the line "Another line" to `output.txt` instead of overwriting it.

Let me know if you'd like further examples or explanations!
