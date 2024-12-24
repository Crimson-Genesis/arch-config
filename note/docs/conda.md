Here’s a list of commonly used Conda commands:

### Basic Conda Commands

1. **Check Conda version:**
   ```bash
   conda --version
   ```

2. **Update Conda:**
   ```bash
   conda update conda
   ```

3. **Install a package:**
   ```bash
   conda install <package_name>
   ```

4. **Install a specific version of a package:**
   ```bash
   conda install <package_name>=<version>
   ```

5. **List installed packages:**
   ```bash
   conda list
   ```

6. **Search for a package:**
   ```bash
   conda search <package_name>
   ```

7. **Uninstall a package:**
   ```bash
   conda remove <package_name>
   ```

8. **Update a package:**
   ```bash
   conda update <package_name>
   ```

9. **Create a new environment:**
   ```bash
   conda create --name <env_name> <package_name>
   ```

10. **Activate an environment:**
    ```bash
    conda activate <env_name>
    ```

11. **Deactivate an environment:**
    ```bash
    conda deactivate
    ```

12. **Remove an environment:**
    ```bash
    conda remove --name <env_name> --all
    ```

13. **List all environments:**
    ```bash
    conda env list
    ```

14. **Export an environment to a YAML file:**
    ```bash
    conda env export --name <env_name> > environment.yml
    ```

15. **Create an environment from a YAML file:**
    ```bash
    conda env create -f environment.yml
    ```

16. **Show information about an environment:**
    ```bash
    conda info --envs
    ```

### Advanced Commands

1. **Channel management (Add a channel):**
   ```bash
   conda config --add channels <channel_name>
   ```

2. **List all channels:**
   ```bash
   conda config --show channels
   ```

3. **Set a default channel:**
   ```bash
   conda config --set channel_priority strict
   ```

4. **Check the Conda configuration:**
   ```bash
   conda config --show
   ```

5. **Clean unused packages and caches:**
   ```bash
   conda clean --all
   ```

6. **Install a package with a specific channel:**
   ```bash
   conda install -c <channel_name> <package_name>
   ```

7. **List all available commands:**
   ```bash
   conda --help
   ```

8. **Check for conflicts in the environment:**
   ```bash
   conda list --revisions
   ```

9. **Rollback to a previous environment revision:**
   ```bash
   conda install --revision <revision_number>
   ```

10. **Create a package from a Conda environment:**
    ```bash
    conda pack
    ```

These are the most common commands you'll use for managing environments and packages in Conda. You can always refer to the official documentation for more advanced commands or specific use cases.
