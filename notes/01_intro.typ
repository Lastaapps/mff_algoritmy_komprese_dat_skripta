#import "../definitions.typ": *

#pagebreak()

= Introduction to Data Compression

== Data Compression
The process of converting an input data stream (source stream / original raw data) into an output data stream (compressed stream / bitstream) that has a smaller size. A code word is a unique binary representation assigned to each distinct data symbol in a dataset.

#info_box(
  title: "Compression algorithm",
  [
    - *Encoding* (compression)
    - *Decoding* (decompression)
  ],
)

== Compression Types
- *Lossless*: the restored and original data are identical
- *Lossy*: the restored data are a "reasonable" approximation of the original

== Methods
- *Static* vs *Adaptive*: Static methods use a fixed model, while adaptive methods update the model as they process the data.
- *Streaming* vs *Block*: Streaming methods process the data as it arrives, while block methods process the data in chunks.

== Goals of Data Compression
- *Save storage*: Reduce the size of files to save disk space.
- *Reduce the transmission bandwidth*: Decrease the amount of data that needs to be sent over a network.

== Measuring Performance

#let performance-table = table(
  columns: (auto, auto, auto),
  align: center,
  [*Measure*], [*Formula*], [*Example*],
  [Compression ratio], [$k / u dot 100%$], [36%],
  [Compression factor], [$u:k$], [3:1],
  [Compression gain], [$(u-k)/u dot 100%$], [64%],
  [bpc (bits per char)], [$K/u$], [1.47 b/c],
  [bpp (bits per pixel)], [], [],
  [Average codeword length], [], [],
)

#info_box(
  [
    $u$ = input data size in Bytes \
    $k$ = compressed data size in Bytes \
    $K$ = compressed data size in bits \
    $k'$ = size of data compressed by a standard algorithm
  ],
)

#performance-table

== Limits of Lossless Compression
- An encoding function $f$ maps $n$-bit strings to strings of length less than $n$.
- The domain of $f$ has size $2^n$.
- The image of $f$ has size at most $2^n - 1$.
- This implies that $f$ cannot be injective. There must be at least one input that is not compressed.

#theorem(
  title: "Pigeonhole Principle for Compression",
  [
    Let $f$ be a compression function for $n$-bit strings. Then there exists at least one string $x$ of length $n$ such that $|f(x)| >= n$.
  ],
)
