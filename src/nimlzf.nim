import std/strutils

{.compile: "lzf/lzf_c.c".}
{.compile: "lzf/lzf_d.c".}

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/lzf".}

proc lzf_compress_c(in_data: pointer, in_len: cuint, out_data: pointer, out_len: cuint): cuint {.cdecl, header: "lzf.h", importc: "lzf_compress".}
proc lzf_decompress_c(in_data: pointer, in_len: cuint, out_data: pointer, out_len: cuint): cuint {.cdecl, header: "lzf.h", importc: "lzf_decompress".}

proc lzfCompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int =
  lzf_compress_c(inData, inLen.cuint, outData, outLen.cuint).int

proc lzfDecompress*(inData: pointer, inLen: int, outData: pointer, outLen: int): int =
  lzf_decompress_c(inData, inLen.cuint, outData, outLen.cuint).int

when isMainModule:
  let data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
  var buffer = newSeqUninitialized[byte](data.len)

  let length = lzfCompress(addr data[0], data.len, addr buffer[0], buffer.len)
  doAssert length > 0
  echo "Decompressed length: ", data.len
  echo "Compressed length: ", length

  let result = newString(data.len)
  let resultLen = lzfDecompress(addr buffer[0], length, addr result[0], result.len)

  doAssert resultLen == data.len
  doAssert result == data
