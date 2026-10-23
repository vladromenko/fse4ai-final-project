import torch  # noqa: F401  (must be imported before the compiled _C module)

from ._C import shifted_relu

__version__ = "0.1.0"
__all__ = ["__version__", "shifted_relu"]