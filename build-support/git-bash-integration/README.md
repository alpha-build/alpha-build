# Bash Utils for Git Bash on Windows

## Description

Utils that don't come with Git Bash by default, like `GNU Make`, `rsync`, \`zstd

## Instructions

1. Get the code in a temporary location as a one off:

   ```bash
   cd <your-repo-root>
   pip install alpha-build-git-bash-utils --target tmp/
   ```

1. Unpack the code:

   ```bash
   tar -xvf tmp/alpha_build_git_bash_utils.tar.gz
   ```

   This will put the code in `<repo-root>/build-support/git-bash-integration/`.

1. Remove the temporary download location:

   ```bash
   rm -rf tmp/
   ```

1. Run Git Bash as administrator and install the relevant utils.

   ```bash
   # from repo root
   ./build-support/git-bash-integration/install_<utility>.sh
   ```
