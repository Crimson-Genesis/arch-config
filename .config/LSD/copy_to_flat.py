import os
import shutil
from pathlib import Path


def copy_files_flat(source_dir, new_dir_name):
    # Convert paths to Path objects
    source_dir = Path(source_dir)

    # Ensure the source directory exists
    if not source_dir.is_dir():
        print(f"Error: The source directory {source_dir} does not exist.")
        return

    # Create the new directory where files will be copied
    new_dir = source_dir.parent / new_dir_name
    new_dir.mkdir(parents=True, exist_ok=True)

    # Walk through the source directory recursively
    for root, dirs, files in os.walk(source_dir):
        for file in files:
            source_file = Path(root) / file
            destination_file = new_dir / file

            # Handle file name conflicts by appending a number if needed
            counter = 1
            while destination_file.exists():
                destination_file = new_dir / f"{file.stem}_{counter}{file.suffix}"
                counter += 1

            # Copy file to the new directory
            shutil.copy2(source_file, destination_file)
            print(f"Copied: {source_file} -> {destination_file}")

    print(f"All files have been copied to {new_dir}.")


# Example usage
source_directory = (
    "/path/to/source_directory"  # Replace with your source directory path
)
new_directory_name = "flat_copy"  # Replace with your desired new directory name
copy_files_flat(source_directory, new_directory_name)
