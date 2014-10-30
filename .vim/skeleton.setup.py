# setup.py template
# Download ez_setup.py
# wget https://bootstrap.pypa.io/ez_setup.py
# structure should be
# ./setup.py
# ./mypackagename/__init__.py
# ./mypackagename/code.py
# ./mypackagename/resources/__init__.py
# ./mypackagename/resources/images/__init__.py
# ./mypackagename/resources/images/pic1.png
# ./mypackagename/resources/images/pic2.png
from ez_setup import use_setuptools
use_setuptools()

setup(
    name="HelloWorld",
    version="0.1",
    packages=find_packages(),
)

