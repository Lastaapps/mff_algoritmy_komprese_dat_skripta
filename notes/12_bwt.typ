#import "../definitions.typ": *

#pagebreak()

= Burrows-Wheeler Transform (BWT)

== Introduction
The Burrows-Wheeler Transform (BWT), developed by Michael Burrows and David Wheeler in 1994, is a data transformation algorithm used primarily as a preprocessing step for lossless data compression. It rearranges the input string into a form that is easier to compress by grouping identical characters together.

== BWT Transformation Process
The core of the BWT involves creating a conceptual matrix of all cyclic shifts of the input string and then sorting these shifts lexicographically.

#info_box(title: "BWT Steps", [
  Given an input string $x$ of length $n$:
  1. Form an $n times n$ matrix where each row is a cyclic shift of $x$. The $i$-th row is $x$ shifted $i$ positions to the left.
  2. Sort all rows of this matrix lexicographically.
  3. The BWT output consists of two parts:
    - $L$: The *last column* of the sorted matrix.
    - $I$: The *index* of the row in the sorted matrix that corresponds to the original input string $x$.
])

*Example*: For $x = "abrakadabra"$
The matrix of cyclic shifts would be formed, then sorted. The last column $L$ would be extracted, along with the index $I$ of the original string in the sorted list.
A key property of $L$ is that identical symbols often appear grouped together, making it highly amenable to further compression.

== Post-Processing for Compression
The output $L$ from the BWT is not directly compressed; it is usually fed into further compression stages:

1. *Move-to-Front (MTF) Transform*: This transform reduces the alphabet size and introduces runs of identical symbols. For each symbol in $L$, it outputs its current index in a dynamically ordered list of the alphabet, and then moves that symbol to the front of the list. This is particularly effective for $L$ because of the grouping of identical symbols.
2. *Run-Length Encoding (RLE)*: After MTF, there are often long runs of zeros or other repeated symbols. RLE is applied to compress these runs.
3. *Entropy Coding*: Finally, the output from RLE (which is now a sequence of integers with a skewed distribution) is compressed using an entropy encoder like Huffman coding or arithmetic coding.

== BWT Decoding
The BWT is a reversible transform. Given $L$ and $I$, the original string $x$ can be perfectly reconstructed.

#info_box(title: "BWT Decoding Algorithm", [
  1. Create the *first column* $F$ of the sorted matrix by sorting the characters in $L$.
  2. Construct a mapping $T$, where $T[i]$ is the position of the character $L[i]$ in the first column $F$ *after* $F$ has been sorted stably (i.e., preserving the original order of identical characters).
  3. The original string $x$ can then be reconstructed by repeatedly tracing back from the position $I$ using the mapping $T$. Specifically, the last character of $x$ is $L[I]$, the second to last is $L[T[I]]$, and so on.
])

== Application: bzip2
The bzip2 compressor heavily relies on the Burrows-Wheeler Transform. Its compression pipeline consists of:

1. *Block Sorting*: The input data is split into blocks (e.g., 100-900KB), and each block is independently transformed using BWT.
2. *Move-to-Front Transform*.
3. *Run-Length Encoding*.
4. *Huffman Coding*: The RLE output is compressed using adaptive Huffman coding. (Earlier versions used arithmetic coding, but this was replaced with Huffman due to patent concerns).

bzip2 generally achieves better compression ratios than gzip/ZIP (which use Deflate), but it is typically slower during both compression and decompression.

== Implementation Notes: Suffix Arrays
Constructing the $n times n$ matrix of cyclic shifts and sorting it explicitly is computationally expensive for large $n$. In practice, the BWT is implemented more efficiently using *suffix arrays*.

- A *suffix array* for a string $x$ is an array of integers that specifies the starting positions of all suffixes of $x$ in lexicographical order.
- This allows the determination of the sorted cyclic shifts (and thus the last column $L$) without explicitly constructing the full matrix. It dramatically reduces the time and memory complexity for the BWT.
