# pylint: disable=all
from pathlib import Path

from setuptools import setup

FILE_PATH = Path(__file__).absolute()
REPO_ROOT = FILE_PATH.parents[3]
README = REPO_ROOT / "README.md"
COMPRESSED_CORE = REPO_ROOT / "alpha_build_core.tar.gz"

setup(
    name="alpha-build-core",
    version="0.1.6",
    description="AlphaBuild's core",
    long_description=README.read_text(),
    long_description_content_type="text/markdown",
    url="https://github.com/alpha-build/alpha-build",
    author="Cristian Matache",
    # author_email="",
    license="MIT",
    packages=[],
    include_package_data=True,
    data_files=[('', [str(COMPRESSED_CORE)])],
)
