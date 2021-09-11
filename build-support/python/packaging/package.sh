#!/usr/bin/env bash

target="$1"
entry_point="$2"

target_dir="${target%/*}"
dist_dir="dist/$target_dir"
deps_dir="deps/$target_dir"
package_path="$dist_dir/$(basename "$target").pyz"
echo -e "Deps dir: $deps_dir"
echo -e "Dist dir: $deps_dir"

# clean old build
rm -r "$deps_dir" "$dist_dir"
mkdir -p "$deps_dir" "$dist_dir"

# include the dependencies from `make reqs-py`
echo "make -s reqs-py on='$target'"
reqs=$(make -s reqs-py on="$target")
echo -e "\n> Requirements for $target:$reqs\n"
# shellcheck disable=SC2086,SC2046
pip install $(echo $reqs | tr '\n' ' ' | tr -d '\r') --target "$deps_dir"

# specify which files to be included in the build
# You probably want to specify what goes here
cp -r -t "$deps_dir/" "$target"

# finally, build!
shiv --site-packages "$deps_dir" --compressed -o "$package_path" -e "$entry_point" -E --reproducible -p "/usr/bin/env python"
