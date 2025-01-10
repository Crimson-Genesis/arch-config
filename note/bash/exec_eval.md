In **Bash**, `exec` and `eval` also have distinct purposes and behaviors. Here's how they differ:

---

### **`exec`**
- **Purpose**: Replaces the current shell process with the command being executed.
- **Behavior**: After `exec`, the current shell process is replaced by the new command, meaning the shell no longer exists if the `exec` command succeeds.
- **Use case**: To run a command without creating a new process, or to redirect file descriptors.

#### Example 1: Replace the shell with another command
```bash
exec ls
# The current shell is replaced by the `ls` command. After it runs, the shell is gone.
```

#### Example 2: Redirect file descriptors
```bash
exec >output.txt 2>error.txt
echo "This will go to output.txt"
>&2 echo "This will go to error.txt"
```

---

### **`eval`**
- **Purpose**: Parses and executes a string as a Bash command.
- **Behavior**: Executes a string of commands after performing an additional layer of parsing.
- **Use case**: To dynamically construct and execute commands.

#### Example 1: Dynamic command construction
```bash
command="ls -l"
eval $command
# This runs `ls -l` after evaluating the variable's content.
```

#### Example 2: Expanding variables or aliases
```bash
var="Hello"
eval echo \$var
# Output: Hello
```

---

### **Key Differences**
| Feature            | `exec`                                    | `eval`                                  |
|---------------------|-------------------------------------------|-----------------------------------------|
| **Purpose**         | Replaces the current shell process.       | Evaluates and executes a string as a command. |
| **Effect on Shell** | The shell process is replaced.            | The shell remains; additional parsing occurs. |
| **Use Cases**       | Running commands directly or redirection. | Dynamically executing constructed commands. |

---

### **Warnings**
- **`exec`**: Be cautious, as it terminates the current shell if used improperly.
- **`eval`**: Avoid using with untrusted input; it can lead to **code injection vulnerabilities**.
        Always validate or sanitize input if you're dynamically constructing commands.
