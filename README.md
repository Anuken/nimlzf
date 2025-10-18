# nimlzf

A simple wrapper for the [libzlf](https://software.schmorp.de/pkg/liblzf.html) compression library.

API:

```nim
#low-level pointer-based procs:
proc lzfCompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int
proc lzfDecompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int

#higher-level string-based procs:
proc lzfCompress*(data: string): string
proc lzfDecompress*(data: string, dataLen: int): string
```
