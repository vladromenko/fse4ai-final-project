# Project Note

## Real issue

The real integration issue, its observed symptom, the fix, and the fixing
commit hash will be recorded after all team branches have been merged and the
integrated project has been tested.

No successful test result is claimed before that verification.

## Unsupported input

The operation contract does not support:

- tensors with a data type other than `torch.float32`;
- tensors located on a device other than CPU.

The exact runtime error messages will be confirmed after integration.

## Profiling

The profiling command is:

```bash
python3 -m cProfile -s cumulative tools/profile_op.py
```

The profiling workload uses a `1000 x 1000` CPU `torch.float32` tensor and
calls `shifted_relu` 50 times.

The measured result will be recorded only after the extension has been built,
