# nimlzf

A simple wrapper for [libzlf](https://software.schmorp.de/pkg/liblzf.html).

API:

```nim
proc lzf_compress*(in_data: pointer, in_len: int, out_data: pointer, out_len: int): int

proc lzf_decompress*(in_data: pointer, in_len: int, out_data: pointer, out_len: int): int
```
