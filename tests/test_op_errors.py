
import pytest
import torch

from fse_ops import shifted_relu


def test_leading_batch_dimension_matches_specification():
    row = torch.tensor([-2.0, 0.5, 2.0, 5.0], dtype=torch.float32)
    x = row.repeat(4, 1)

    expected = torch.relu(x - 1)
    result = shifted_relu(x)

    assert result.shape == x.shape
    assert torch.equal(result, expected)


def test_integer_tensor_raises_runtime_error_from_cpp():
    x = torch.tensor([1, 2, 3], dtype=torch.int64)

    with pytest.raises(RuntimeError):
        shifted_relu(x)


def test_float64_tensor_is_rejected():
    x = torch.tensor([0.5, 2.0, 5.0], dtype=torch.float64)

    with pytest.raises(RuntimeError):
        shifted_relu(x)
