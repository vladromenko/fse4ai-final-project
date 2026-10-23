from setuptools import find_packages, setup
from torch.utils.cpp_extension import BuildExtension, CppExtension

setup(
    name="fse-ops",
    version="0.1.0",
    description="CPU-only shifted ReLU extension for PyTorch",
    python_requires=">=3.10",
    install_requires=["torch>=2.0"],
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    ext_modules=[
        CppExtension(
            name="fse_ops._C",
            sources=["src/fse_ops/ops.cpp"],
        )
    ],
    cmdclass={"build_ext": BuildExtension},
    zip_safe=False,
)