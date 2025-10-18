# nimlzf

A simple wrapper for [libzlf](https://software.schmorp.de/pkg/liblzf.html).

API:

```nim
proc lzfCompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int

proc lzfDecompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int
```
