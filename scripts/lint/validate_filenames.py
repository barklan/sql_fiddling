#!/usr/bin/env python3
import os
import typing as t

a: str = 4 # type: ignore

EXTS_TO_CHECK = (".py", ".ipynb", ".go", ".sql")

def good_file_paths(top_dir: str = ".") -> t.Iterator[str]:
    for dir_path, dir_names, filenames in os.walk(top_dir):
        dir_names[:] = [d for d in dir_names if d != "scripts" and d[0] not in "._"]
        for filename in filenames:
            if filename == "__init__.py":
                continue
            if os.path.splitext(filename)[1] in (".py", ".ipynb", ".go", ".sql"):
                yield os.path.join(dir_path, filename).lstrip("./")


print("Checking for validity of filenames of following files: ", EXTS_TO_CHECK)

filepaths = list(good_file_paths())
assert filepaths, "good_file_paths() failed!"

upper_files = [file for file in filepaths if file != file.lower()]
if upper_files:
    print(f"{len(upper_files)} files contain uppercase characters:")
    print("\n".join(upper_files) + "\n")

space_files = [file for file in filepaths if " " in file]
if space_files:
    print(f"{len(space_files)} files contain space characters:")
    print("\n".join(space_files) + "\n")

hyphen_files = [file for file in filepaths if "-" in file]
if hyphen_files:
    print(f"{len(hyphen_files)} files contain hyphen characters:")
    print("\n".join(hyphen_files) + "\n")

bad_files = len(upper_files + space_files + hyphen_files)
if bad_files:
    import sys

    sys.exit(bad_files)
else:
    print("Filenames are good.")
