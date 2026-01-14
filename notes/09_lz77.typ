#import "../definitions.typ": *

#pagebreak()

= Dictionary Methods (LZ77)

== Introduction to Dictionary Methods
Dictionary methods are a class of data compression algorithms that achieve compression by replacing repeated occurrences of data sequences (phrases) with shorter codes. The core idea is:
- Store frequently occurring repeated phrases in a "dictionary."
- When a phrase is encountered in the input text, replace its occurrence with a pointer to its entry in the dictionary.

*Challenges and Solutions*:
- Constructing an *optimal* dictionary is computationally hard (NP-hard). Practical algorithms typically use greedy approaches.
- The dictionary needs to be available for decoding. Dynamic dictionary methods build the dictionary on the fly, allowing the decoder to reconstruct it in parallel with the encoder.

LZ77 (Lempel-Ziv 1977) and LZ78 (Lempel-Ziv 1978) are foundational algorithms in this category.

== LZ77 Algorithm (Sliding Window)
The LZ77 algorithm, also known as the sliding window algorithm, uses a dynamic dictionary implicitly formed by a "sliding window" over the previously seen data.

#info_box(title: "LZ77 Components", [
  - *Search Buffer (or Sliding Window)*: A fixed-size buffer that holds a portion of the recently processed input data. This acts as the implicit dictionary.
  - *Look-Ahead Buffer*: A fixed-size buffer that holds the portion of the input data yet to be encoded.
])

=== Initialization
The search buffer is conceptually filled with "spaces" or null characters initially. Input data is read into the look-ahead buffer.

=== Encoding Process
For each step, the encoder searches for the longest string $S$ in the search buffer that matches a prefix of the string in the look-ahead buffer.

#info_box(title: "LZ77 Output Triple $(i, j, z)$", [
  The algorithm outputs a triple $(i, j, z)$ for each matched string $S$:
  - $i$: The *offset* or distance from the current position in the look-ahead buffer to the beginning of the match $S$ in the search buffer.
  - $j$: The *length* of the matched string $S$.
  - $z$: The *next symbol* in the look-ahead buffer immediately following the matched string $S$. If no match is found, $j=0$ and $i=0$, and only the symbol $z$ is encoded.
])

=== Window Movement
After encoding a match of length $j$ and the following symbol $z$, the window (both search and look-ahead buffers) slides $j+1$ symbols to the right.

=== Example Encoding (conceptual)
Let's consider encoding "accabracadabrarrar" with a search buffer and look-ahead buffer.
- Initially, the search buffer is empty, and the look-ahead buffer contains "accabracadabrarrar".
- No match for 'a', so output $(0, 0, 'a')$. Window slides 1.
- No match for 'c', so output $(0, 0, 'c')$. Window slides 1.
- Match "ca" in search buffer. Output $("offset", "length", 'b')$.
- And so on.

*Typical Window Sizes*:
- Search window: $2^{12}$ to $2^{16}$ bytes (e.g., gzip uses $2^{15}$ B).
- Look-ahead buffer: Tens to hundreds of bytes (e.g., gzip uses 256 B).

== Properties of LZ77
- *Compression Speed*: Typically slower during compression due to the need to search the sliding window.
- *Decompression Speed*: Generally faster because it only requires reading the triples and copying data from the decoded stream.
- *Applications*: Well-suited for single-pass compression and multiple decompressions (e.g., archived files).

== LZ77 Variants

=== LZSS (Lempel-Ziv-Storer-Szymanski, 1982)
LZSS is a refinement of LZ77 that often achieves better compression ratios.
- It replaces the triple $(i, j, z)$ with either a pair $(i, j)$ (pointer to a match) or a literal symbol $z$.
- A *bit indicator* (e.g., a '0' or '1' bit) is used to distinguish between a pointer and a literal.
- Pointers are only emitted if the matched phrase length $j$ is greater than some minimum threshold $p$ (e.g., if a pointer uses 16 bits and a literal uses 8 bits, $p=1$). Otherwise, the literal $z$ is simply copied to the output.
- The sliding window is often implemented as a circular buffer.

=== LZB (Bell, 1987)
LZB focuses on more efficient encoding of the $(i, j)$ pairs from LZSS.
- Offset $i$ is encoded using a binary code with increasing length (e.g., based on position within the window).
- Length $j$ is encoded using an Elias Gamma code, which is efficient for skewed distributions (shorter lengths are more common).

=== LZH (Brent, 1987)
LZH combines LZSS with Huffman coding to further improve compression.
- It uses a two-pass approach:
  1. First pass: LZSS encoding is performed, and statistics (symbol counts) for the literal symbols and for the offset/length components of the pointers are collected.
  2. Second pass: A static Huffman code is built based on these collected statistics, and the LZSS output (literals and pointers) is Huffman-encoded.

== The Deflate Algorithm
Deflate is a lossless data compression algorithm that is a combination of LZ77 and Huffman coding. It was developed by Phil Katz (1991) and is widely used in popular formats like ZIP, GZIP, PNG, and JAR.

#info_box(title: "Deflate Algorithm Overview", [
  - *Core Components*: A combination of LZSS and Huffman coding.
  - *Sliding Window/Search Buffer*: Typically 32 KB.
  - *Look-Ahead Buffer*: Typically 258 bytes.
  - *Input Processing*: Data is divided into blocks. Each block has a 3-bit header:
    - 1 bit: Indicates if it's the last block.
    - 2 bits: Specifies the block type (no compression, fixed Huffman codes, or dynamic Huffman codes).
])

=== Deflate Block Types
Deflate supports three types of blocks:
1. *No compression*: Stored as raw, uncompressed data.
2. *Fixed Huffman codes*: Uses predefined Huffman trees for literals/lengths and distances.
3. *Dynamic Huffman codes*: Uses Huffman trees generated dynamically based on the statistics of the current block. This involves transmitting the Huffman tree definitions along with the compressed data.

The dynamic Huffman block type uses two Huffman trees: one for literals (0-255) and match lengths (257-285), and another for distances (0-29).

== Disadvantages of LZ77
- *Limited Look-Ahead*: The fixed size of the look-ahead buffer means that long matches that extend beyond its boundary cannot be found, potentially limiting compression for highly repetitive patterns.
- *Limited Search Window*: The fixed size of the search buffer (sliding window) means that matches can only be found within a certain distance from the current position. If a repeated phrase occurred further back in the stream, it won't be identified.
- *Greedy Approach*: The greedy nature of finding the longest match at each step does not guarantee global optimality. A shorter match now might enable better overall compression later.
