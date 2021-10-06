from pathlib import Path

from setuptools import setup

README = Path(__file__).absolute().parents[3] / "README.md"

setup(
    name="alpha-build-core",
    version="0.0.1",
    description="AlphaBuild's core",
    long_description=README.read_text(),
    long_description_content_type="text/markdown",
    url="https://github.com/cristianmatache/alpha-build",
    author="Cristian Matache",
    # author_email="",
    license="MIT",
    packages=[],
    include_package_data=True,
    package_data={'': ['**/*.mk']},
)
