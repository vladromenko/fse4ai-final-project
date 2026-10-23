# Project Note

## Real issue

The CI run on the original `feature/tests-ci` branch failed during `ruff check .` with error `I001`. The test files started with an unnecessary blank line, so Ruff reported incorrectly formatted import blocks.

The files were formatted with Ruff. The fix was committed as `a0a9b0b` (`fix: format tests for CI`). After the corrected branches were merged, the final CI run on `main` completed successfully.

## Unsupported input

The operation supports only CPU tensors with the `torch.float32` data type.

A CPU tensor with the `torch.float64` data type was tested inside the final Docker image. The C++ `TORCH_CHECK` rejected it with:

```text
RuntimeError
shifted_relu: input must be torch.float32
```

## Profiling

Profiling was performed inside the Linux Docker image with:

```bash
docker run --rm \
  -v "$PWD/tools:/opt/tools:ro" \
  fse-ops:0.1 \
  python3 -m cProfile -s cumulative /opt/tools/profile_op.py
```

The workload used a `1000 x 1000` CPU `torch.float32` tensor and called `shifted_relu` 50 times.

The profiler reported:

```text
1091730 function calls (1067818 primitive calls) in 0.609 seconds
1  0.000  0.000  0.020  0.020 profile_op.py:6(main)
```

The complete profiling run took `0.609` seconds. The cumulative time of the measured workload in `main` was `0.020` seconds.