
import torch

from fse_ops import shifted_relu


def test_output_shape():
    x = torch.ones((2, 3, 4), dtype=torch.float32)
    result = shifted_relu(x)
    assert result.shape == x.shape


def test_output_dtype():
    x = torch.tensor([0.0, 2.0, 5.0], dtype=torch.float32)
    result = shifted_relu(x)
    assert result.dtype == torch.float32


def test_exact_numeric_example():
    x = torch.tensor([0.0, 1.0, 2.0, 4.0], dtype=torch.float32)
    expected = torch.relu(x - 1)
    result = shifted_relu(x)
    assert torch.equal(result, expected)


def test_varied_values_defeat_fake_implementations():
    x = torch.tensor([-3.0, 0.5, 2.0, 7.0], dtype=torch.float32)
    expected = torch.relu(x - 1)
    result = shifted_relu(x)
    assert torch.equal(result, expected)
    assert not torch.equal(result, x)
