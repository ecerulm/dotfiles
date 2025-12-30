"""Package name and what it does

Usually put things in
<packagename/__init__.py (def main())
<packagename>/module.py
tox.ini

See:
https://python-packaging-user-guide.readthedocs.org/en/latest/distributing/
"""

from setuptools import setup, find_packages
from setuptools.command.test import test as TestCommand
from codecs import open
from os import path
import sys

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()


class Tox(TestCommand):
    user_options = [('tox-args=', 'a', 'Arguments to pass to tox')]
    def initialize_options(self):
        TestCommand.initialize_options(self)
        self.tox_args = None
    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True
    def run_tests(self):
        import tox
        import shlex
        args = self.tox_args
        if args:
            args = shlex.split(self.tox_args)
        errno = tox.cmdline(args=args)
        sys.exit(errno)

setup(
    name='packagename',

    version='0.1.0',

    description='description of package',
    long_description=long_description,
    url='http://rubenlaguna.com',
    author='Ruben Laguna',
    author_email='ruben.laguna@gmail.com',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Programming Language :: Python :: 3.5',
        ],
    keywords='puzzle',
    packages=find_packages(exclude=('contrib', 'docs', 'tests')),
    extras_require={
        "testing": ['pytest', 'coverage', 'pytest-cov']
        },
    tests_require=['tox'],
    entry_points={
        'console_scripts': [
            'scriptname=packagename:main'
            ]
        },
    cmdclass={
        'test': Tox},
    )

