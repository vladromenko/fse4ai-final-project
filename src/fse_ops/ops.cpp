#include <torch/extension.h>

torch::Tensor shifted_relu(const torch::Tensor& input) {
  TORCH_CHECK(input.device().is_cpu(), "shifted_relu: input must be on CPU");
  TORCH_CHECK(input.scalar_type() == torch::kFloat32,
              "shifted_relu: input must be torch.float32");
  return torch::relu(input - 1.0);
}

PYBIND11_MODULE(TORCH_EXTENSION_NAME, module) {
  module.def("shifted_relu", &shifted_relu, "relu(input - 1.0) for CPU float32 tensors");
}