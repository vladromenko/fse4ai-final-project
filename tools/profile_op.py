import torch

from fse_ops import shifted_relu


def main() -> None:
    x = torch.randn(
        (1000, 1000),
        dtype=torch.float32,
        device="cpu",
    )

    result = x

    for _ in range(50):
        result = shifted_relu(x)

    assert result.shape == (1000, 1000)
    assert result.dtype == torch.float32
    assert result.device.type == "cpu"


if __name__ == "__main__":
    main()