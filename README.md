# nimlzf

A simple wrapper for the [liblzf](https://software.schmorp.de/pkg/liblzf.html) compression library.

API:

```nim
#low-level pointer-based procs:
proc lzfCompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int
proc lzfDecompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int

#higher-level string-based procs:
proc lzfCompress[T: byte | char](data: openArray[T]): string
proc lzfDecompress[T: byte | char](data: openArray[T], decompressedLen: int): string
```

Note that `lzfCompress` will fail (throw an IOError) if the data is too short and/or cannot be compressed below its original size.
