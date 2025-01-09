The `${}` syntax in Bash is used for **parameter expansion**, which allows you to manipulate the value of a variable in various ways.  
The `${filename%.*}` and `${filename##.*}` patterns you asked about are just a few examples of what you can do with this powerful feature.  

Let’s dive into the details of how **parameter expansion** works, particularly focusing on string manipulation.

### **Basic Syntax:**
```bash
${parameter}
```
This simply expands to the value of `parameter`.

### **String Manipulation Using `%` and `##`**

#### 1. **Removing the Shortest Match with `%` (Remove from the Right)**
```bash
${parameter%word}
```
- Removes the shortest match of `word` from the **end** of `parameter`.
- Example:
  ```bash
  filename=".formats.txt"
  name="${filename%.*}"
  echo "$name"
  ```
  Output:
  ```
  .formats
  ```
  - Here, `${filename%.*}` removes the `.txt` part from the end of the string, leaving `.formats`.
  - **Note**: The `*` matches the **shortest** string that ends with a dot (`.`), so it removes only the last part (extension).

#### 2. **Removing the Longest Match with `%%` (Remove from the Right)**
```bash
${parameter%%word}
```
- Removes the longest match of `word` from the **end** of `parameter`.
- Example:
  ```bash
  filename="archive.tar.gz"
  name="${filename%%.*}"
  echo "$name"
  ```
  Output:
  ```
  archive
  ```
  - Here, `${filename%%.*}` removes everything after the first dot, leaving only the `archive` part of the string.
  - The `%%` pattern ensures the **longest match**, removing all content after the first dot.

#### 3. **Removing the Shortest Match with `#` (Remove from the Left)**
```bash
${parameter#word}
```
- Removes the shortest match of `word` from the **beginning** of `parameter`.
- Example:
  ```bash
  filename="dir/filename.txt"
  name="${filename#*/}"
  echo "$name"
  ```
  Output:
  ```
  filename.txt
  ```
  - Here, `${filename#*/}` removes everything up to and including the first `/`, leaving `filename.txt`.
  - The `#` matches the shortest string (up to the first `/`).

#### 4. **Removing the Longest Match with `##` (Remove from the Left)**
```bash
${parameter##word}
```
- Removes the longest match of `word` from the **beginning** of `parameter`.
- Example:
  ```bash
  filename="dir/subdir/filename.txt"
  name="${filename##*/}"
  echo "$name"
  ```
  Output:
  ```
  filename.txt
  ```
  - Here, `${filename##*/}` removes everything before and including the last `/`, leaving only `filename.txt`.
  - The `##` pattern ensures the **longest match**, so it removes everything before the last `/`.

---

### **Other Useful Parameter Expansion Techniques**

#### 5. **Default Values:**
You can set a default value for a variable if it is unset or null using the following syntax:
```bash
${parameter:-default_value}
```
- If `parameter` is unset or null, it will use `default_value`.
- Example:
  ```bash
  unset filename
  name="${filename:-default.txt}"
  echo "$name"
  ```
  Output:
  ```
  default.txt
  ```

#### 6. **Setting a Default Value:**
You can assign a default value to a variable if it is unset or null:
```bash
${parameter:=default_value}
```
- If `parameter` is unset or null, it will be assigned `default_value`.
- Example:
  ```bash
  unset filename
  name="${filename:=default.txt}"
  echo "$name"
  ```
  Output:
  ```
  default.txt
  ```

#### 7. **Checking for Null or Unset Variables:**
You can check if a variable is unset or null using:
```bash
${parameter:?error_message}
```
- If `parameter` is unset or null, it will display the `error_message` and exit the script.
- Example:
  ```bash
  unset filename
  name="${filename:?Error: filename is not set}"
  echo "$name"
  ```
  Output:
  ```
  Error: filename is not set
  ```

#### 8. **Length of a String:**
You can get the length of a string using:
```bash
${#parameter}
```
- This gives the length of `parameter` in characters.
- Example:
  ```bash
  filename="hello.txt"
  length="${#filename}"
  echo "$length"
  ```
  Output:
  ```
  9
  ```

#### 9. **Substituting a String (Search and Replace):**
You can replace parts of a string with another string:
```bash
${parameter/old_string/new_string}
```
- Replaces the **first** occurrence of `old_string` with `new_string`.
- Example:
  ```bash
  filename="hello.txt"
  new_filename="${filename/.txt/.bak}"
  echo "$new_filename"
  ```
  Output:
  ```
  hello.bak
  ```

To replace all occurrences:
```bash
${parameter//old_string/new_string}
```

#### 10. **Substring Extraction:**
You can extract a substring from a string:
```bash
${parameter:start_position:length}
```
- **`start_position`**: The position to start extracting (zero-indexed).
- **`length`**: The length of the substring to extract.
- Example:
  ```bash
  filename="hello.txt"
  substring="${filename:0:5}"
  echo "$substring"
  ```
  Output:
  ```
  hello
  ```

---

### **Putting It All Together**

Here’s a more complex example:
```bash
filename="dir/subdir/hello.world.txt"

# Extract file name without extension
name="${filename##*/}"
base_name="${name%.*}"
# Extract extension
extension="${name##*.}"

echo "Full filename: $filename"
echo "Base name: $base_name"
echo "Extension: $extension"
```

#### Output:
```
Full filename: dir/subdir/hello.world.txt
Base name: hello.world
Extension: txt
```

---

### **Summary of Commonly Used Patterns:**

- **`${parameter}`**: Expands the value of `parameter`.
- **`${parameter%pattern}`**: Removes the shortest match of `pattern` from the right.
- **`${parameter%%pattern}`**: Removes the longest match of `pattern` from the right.
- **`${parameter#pattern}`**: Removes the shortest match of `pattern` from the left.
- **`${parameter##pattern}`**: Removes the longest match of `pattern` from the left.
- **`${parameter:-default}`**: Uses `default` if `parameter` is unset or null.
- **`${parameter:=default}`**: Assigns `default` to `parameter` if it is unset or null.
- **`${#parameter}`**: Returns the length of `parameter`.
- **`${parameter/old/new}`**: Replaces the first occurrence of `old` with `new`.
- **`${parameter//old/new}`**: Replaces all occurrences of `old` with `new`.
- **`${parameter:start:length}`**: Extracts a substring.

---

### Conclusion:
Bash parameter expansion is an incredibly versatile tool for string manipulation. It allows you to perform a wide variety of tasks,  
from extracting file extensions to modifying strings and handling default values. Understanding these expansions can make your scripts more powerful and efficient.  

