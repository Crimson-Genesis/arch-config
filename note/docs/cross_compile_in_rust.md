If you prefer to use `rustc` directly instead of `cargo`, here’s how you can compile a Rust program for Windows on your Arch Linux system:

---

### Step 1: Install Rust and Cross-Compilation Tools
Follow the instructions to set up the cross-compilation environment:

1. Install Rust and `rustup` if not already installed:
   ```bash
   sudo pacman -S rustup mingw-w64-gcc
   rustup install stable
   rustup default stable
   ```

2. Add the Windows target:
   ```bash
   rustup target add x86_64-pc-windows-gnu
   ```

---

### Step 2: Write a Simple Rust Program
Create a file called `main.rs` with your Rust code:

```rust
fn main() {
    println!("Hello, Windows!");
}
```

---

### Step 3: Compile with `rustc`
Use `rustc` to compile the program for Windows. For a 64-bit Windows target, run:

```bash
rustc --target=x86_64-pc-windows-gnu -C opt-level=3 -o hello.exe main.rs
```

For a 32-bit Windows target:

```bash
rustc --target=i686-pc-windows-gnu -C opt-level=3 -o hello.exe main.rs
```

Explanation of the flags:
- `--target=x86_64-pc-windows-gnu`: Specifies the Windows 64-bit target.
- `-C opt-level=3`: Enables optimizations for release builds.
- `-o hello.exe`: Specifies the output file name.

---

### Step 4: Transfer and Test
The generated `hello.exe` file can be copied to your friend's Windows device. Test it there to ensure it works correctly.

---

### Optional: Debugging and Dependencies
If your program depends on additional libraries, ensure the necessary `.dll` files are included with the executable. You can find these in the MinGW directory (e.g., `/usr/x86_64-w64-mingw32/bin`).

To get the username of the current user in Rust, you can use the [`whoami`](https://docs.rs/whoami) crate or the standard library (`std::env`) for platform-specific solutions. Here's how:

---

### **Option 1: Using the `whoami` Crate**
The `whoami` crate provides a simple and cross-platform way to retrieve the username.

#### Step 1: Add `whoami` to your project
If you are using `cargo`, add the crate to your `Cargo.toml`:

```toml
[dependencies]
whoami = "1.3"
```

#### Step 2: Code Example

```rust
fn main() {
    let username = whoami::username();
    println!("Hello, {}!", username);
}
```

#### Output Example
If the current user's username is `alice`, the output will be:

```
Hello, alice!
```

---

### **Option 2: Using the Standard Library**
The standard library can also be used, but the implementation is platform-specific.

#### Code Example for Unix-like Systems (e.g., Linux, macOS):
You can use the `std::env` module and environment variables:

```rust
use std::env;

fn main() {
    if let Some(username) = env::var_os("USER") {
        println!("Hello, {}!", username.to_string_lossy());
    } else {
        println!("Could not retrieve username.");
    }
}
```

#### Code Example for Windows:
On Windows, the equivalent environment variable is `USERNAME`:

```rust
use std::env;

fn main() {
    if let Some(username) = env::var_os("USERNAME") {
        println!("Hello, {}!", username.to_string_lossy());
    } else {
        println!("Could not retrieve username.");
    }
}
```

#### Cross-Platform Example
You can combine both methods for a simple cross-platform solution:

```rust
use std::env;

fn main() {
    let username = env::var_os("USER")
        .or_else(|| env::var_os("USERNAME"))
        .map(|u| u.to_string_lossy().into_owned())
        .unwrap_or_else(|| "Unknown".to_string());

    println!("Hello, {}!", username);
}
```

---

### **Choosing Between Methods**
- **Use `whoami`** for simplicity and portability.
- **Use the standard library** for minimal dependencies but handle platform-specific quirks.
