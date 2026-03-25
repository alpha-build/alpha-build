# pylint: disable=all
from pathlib import Path

from setuptools import setup

FILE_PATH = Path(__file__).absolute()
REPO_ROOT = FILE_PATH.parents[2]
print(REPO_ROOT)

COMPRESSED_GIT_BASH_UTILS = REPO_ROOT / "alpha_build_git_bash_utils.tar.gz"
README = REPO_ROOT / "build-support" / "git-bash-integration" / "README.md"

setup(
    name="alpha-build-git-bash-utils",
    version="0.0.5",
    description="AlphaBuild's utils for Git Bash on Windows",
    long_description=README.read_text(),
    long_description_content_type="text/markdown",
    url="https://github.com/alpha-build/alpha-build",
    author="Cristian Matache",
    # author_email="",
    license="MIT",
    packages=[],
    include_package_data=True,
    data_files=[('', [str(COMPRESSED_GIT_BASH_UTILS)])],
)
