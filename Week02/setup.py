from setuptools import setup
from Cython.Build import cythonize

setup(
    name='target_mean',
    ext_modules=cythonize("./target_mean_cython.pyx"),
    zip_safe=False,
)