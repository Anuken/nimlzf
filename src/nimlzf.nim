import std/strutils

{.compile: "lzf/lzf_c.c".}
{.compile: "lzf/lzf_d.c".}

proc currentSourceDir(): string {.compileTime.} =
  result = currentSourcePath().replace("\\", "/")
  result = result[0 ..< result.rfind("/")]

{.passC: "-I" & currentSourceDir() & "/lzf".}

proc lzf_compress_c(in_data: pointer, in_len: cuint, out_data: pointer, out_len: cuint): cuint {.cdecl, header: "lzf.h", importc: "lzf_compress".}
proc lzf_decompress_c(in_data: pointer, in_len: cuint, out_data: pointer, out_len: cuint): cuint {.cdecl, header: "lzf.h", importc: "lzf_decompress".}

proc lzf_compress*(in_data: pointer, in_len: int, out_data: pointer, out_len: int): int =
  lzf_compress_c(in_data, in_len.cuint, out_data, out_len.cuint).int

proc lzf_decompress*(in_data: pointer, in_len: int, out_data: pointer, out_len: int): int =
  lzf_decompress_c(in_data, in_len.cuint, out_data, out_len.cuint).int

when isMainModule:
  let data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
  var buffer = newSeqUninitialized[byte](data.len)

  let length = lzf_compress(addr data[0], data.len, addr buffer[0], buffer.len)
  doAssert length > 0
  echo "Decompressed length: ", data.len
  echo "Compressed length: ", length

  let result = newString(data.len)
  let resultLen = lzf_decompress(addr buffer[0], length, addr result[0], result.len)

  doAssert resultLen == data.len
  doAssert result == data
