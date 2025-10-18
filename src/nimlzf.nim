import std/strutils

{.compile: "lzf/lzf_c.c".}
{.compile: "lzf/lzf_d.c".}

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/lzf".}

var errno {.importc, header: "<errno.h>".}: cint
proc strerror(errnum: cint): cstring {.importc, header: "<string.h>".}

proc lzf_compress_c(in_data: pointer, in_len: cuint, out_data: pointer, out_len: cuint): cuint {.cdecl, header: "lzf.h", importc: "lzf_compress".}
proc lzf_decompress_c(in_data: pointer, in_len: cuint, out_data: pointer, out_len: cuint): cuint {.cdecl, header: "lzf.h", importc: "lzf_decompress".}

proc lzfCompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int =
  if inLen == 0 or outLen == 0: raise IOError.newException("LZF data length must not be 0")
  result = lzf_compress_c(inData, inLen.cuint, outData, outLen.cuint).int
  if result == 0: raise IOError.newException("Failed to compress LZF data")

proc lzfDecompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int =
  if inLen == 0 or outLen == 0: raise IOError.newException("LZF data length must not be 0")
  result = lzf_decompress_c(inData, inLen.cuint, outData, outLen.cuint).int
  if result == 0: raise IOError.newException("Failed to decompress LZF data: " & $strerror(errno) & " (error code " & $errno & ")")

proc lzfCompress*(data: string): string =
  result = newString(data.len) #would like to use newStringUninit, but that requires a newer nim version
  let length = lzfCompress(addr data[0], data.len, addr result[0], result.len)
  result.setLen(length)

proc lzfDecompress*(data: string, dataLen: int): string =
  result = newString(dataLen)
  discard lzfDecompress(addr data[0], data.len, addr result[0], dataLen)

when isMainModule:
  let data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
  
  let compressed = lzfCompress(data)

  doAssert compressed.len > 0
  echo "Decompressed length: ", data.len
  echo "Compressed length: ", compressed.len

  let result = lzfDecompress(compressed, data.len)

  doAssert result == data
