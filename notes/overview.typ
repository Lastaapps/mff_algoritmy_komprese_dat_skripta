#import "../definitions.typ": *

#pagebreak()

= Overview of Data Compression Algorithms

This document provides a brief overview of the main categories of data compression algorithms discussed in this course.

== Other sources
- #link("https://github.com/Lastaapps/mff_algoritmy_komprese_dat_skripta/")[Latest version]  of this lecture notes.
- #link("https://wiki.matfyz.cz/NSWI072")[Matfyz Wiki]  page.
- #link("https://youtube.com/playlist?list=PLiqLGdpbmTW0vTp-V-5Rr9c3KzCvCg4HQ")[Videos]  explaining some of the topics discussed here.

== Information Theory
Information theory provides a mathematical foundation for data compression, defining the absolute limits on how much data can be compressed.

=== Entropy
Entropy, introduced by Claude Shannon, is a measure of the uncertainty or "information content" of a random variable. It provides a theoretical lower bound for lossless compression.

#info_box(title: "Entropy $H(X)$", [
  For a discrete random variable $X$ with probability distribution $p(x)$, the entropy is:
  $ H(X) = - sum_(x) p(x) log_2 p(x) $
  - It represents the average number of bits required to encode a symbol from the source.
  - A higher entropy indicates a more random and less compressible source.
  - Shannon's Source Coding Theorem states that the average length of any uniquely decodable code will be greater than or equal to the entropy: $L(C) >= H(X)$.
])

== Statistical Methods
Statistical methods assign codewords to symbols based on their probabilities. More frequent symbols receive shorter codes.

#info_box(title: "Huffman Coding", [
  This method builds a prefix code tree based on symbol frequencies, assigning shorter codes to more frequent symbols.
  - *Use Cases*: General-purpose compression (e.g., as part of Deflate), file archiving.
  - *Advantages*: Simple to implement, guarantees an optimal prefix code for a known probability distribution. The average code length $L$ is bounded by $H(X) <= L < H(X) + 1$.
  - *Disadvantages*: Requires two passes over the data (one to build frequencies, one to encode), not optimal for distributions with probabilities that are not powers of two.
])

#info_box(title: "Adaptive Huffman (FGK)", [
  This is a single-pass version of Huffman coding that dynamically updates the code tree as it processes the data, adapting to changing probabilities.
  - *Use Cases*: Situations where the data statistics change over time, streaming data.
  - *Advantages*: Single-pass algorithm, adapts to changing data probabilities.
  - *Disadvantages*: More complex to implement than static Huffman, can be less efficient than a two-pass approach if the data is static.
])

#info_box(title: "Huffman vs. Arithmetic Coding", [
  The fundamental difference is that Huffman coding assigns an integer number of bits to each symbol, while arithmetic coding can effectively assign fractional numbers of bits, leading to better compression.
])

#info_box(title: "Arithmetic Coding", [
  Encodes an entire message into a single fraction within the interval $[0, 1)$, with the size of the final sub-interval proportional to the message probability.
  - *Use Cases*: High-performance compression where compression ratio is critical (e.g., in some image and video codecs).
  - *Advantages*: Achieves near-optimal compression, even for non-power-of-two probability distributions. The average code length $L$ is bounded by $H(X) <= L < H(X) + 2$.
  - *Disadvantages*: Can be slower than Huffman coding, historically encumbered by patents.
])

#info_box(title: "Prediction by Partial Matching (PPM)", [
  This is a statistical method that uses a finite context model to predict the next symbol based on the preceding symbols, then encodes it using arithmetic coding.
  - *Use Cases*: High-performance text compression.
  - *Advantages*: Excellent compression ratios for text and other data with contextual dependencies.
  - *Disadvantages*: High memory usage, computationally intensive.
])

== Dictionary Methods
Dictionary methods replace repeated sequences of data with references to a dictionary.

#info_box(title: "LZ77 (Lempel-Ziv 1977)", [
  This dictionary method uses a sliding window to find repeated sequences in recently seen data and replaces them with a (length, distance) pair.
  - *Use Cases*: General-purpose file compression (e.g., as part of Deflate in ZIP/GZIP/PNG).
  - *Advantages*: Fast decompression, single-pass algorithm.
  - *Disadvantages*: Compression can be slow due to the search for matches, greedy approach is not always optimal, limited by window size.
])

#info_box(title: "LZSS (Lempel-Ziv-Storer-Szymanski)", [
  - *Use Cases*: A popular variant of LZ77, often used in practice.
  - *Advantages*: Improves on LZ77 by adding a flag to indicate whether the following data is a literal or a length-distance pair, which avoids the problem of pointers being longer than the string they replace.
  - *Disadvantages*: Still limited by window size.
])

#info_box(title: "LZ78", [
  - *Use Cases*: Predecessor to LZW.
  - *Advantages*: Builds an explicit dictionary of phrases encountered in the input.
  - *Disadvantages*: The dictionary can grow very large. The output consists of pairs (dictionary index, next character).
])

#info_box(title: "LZW (Lempel-Ziv-Welch)", [
  - *Use Cases*: GIF images, `compress` utility.
  - *Advantages*: An improvement on LZ78. The dictionary is initialized with all possible single-character strings. The output consists only of dictionary indices.
  - *Disadvantages*: Less effective than modern methods, patents were an issue historically.
])

== Lempel-Ziv Family Differences

- *LZ77*: Refers to a sliding window of recently seen text. Output is a `(length, distance, next_char)` triplet.
- *LZSS*: An improvement on LZ77. Uses a flag to distinguish between a literal and a `(length, distance)` pair. This avoids expanding the data.
- *LZ78*: Builds a dictionary of phrases from the input stream. Output is a `(dictionary_index, next_char)` pair.
- *LZW*: An improvement on LZ78. The dictionary is initialized with all single characters. Output is just a stream of dictionary indices.

== Block-Sorting Methods
These methods rearrange the data into a form that is easier to compress, typically by grouping similar characters together.

#info_box(title: "Burrows-Wheeler Transform (BWT)", [
  - *Use Cases*: High-performance text compressors (e.g., bzip2). It is a preprocessing step, not a compressor itself.
  - *Advantages*: Excellent at preparing data for subsequent compression stages (like MTF and RLE), leading to high compression ratios.
  - *Disadvantages*: Computationally intensive, particularly the sorting step (though suffix arrays help). It is a block-based algorithm, so not suitable for streaming.
])

== Lossy Methods
Lossy methods achieve high compression ratios by permanently discarding some information that is deemed less important or imperceptible.

#info_box(title: "Quantization", [
  - *Use Cases*: The core of almost all lossy audio, image, and video compression.
  - *Advantages*: Provides high compression ratios and allows for a direct trade-off between quality and file size.
  - *Disadvantages*: Information loss is irreversible; can introduce artifacts if done too aggressively.
  - *Types*: Scalar, Vector, Uniform, Non-uniform, Adaptive.
])

#info_box(title: "Differential Encoding (DPCM, ADPCM)", [
  - *Use Cases*: Speech and audio signals with high sample-to-sample correlation (e.g., G.722, G.726).
  - *Advantages*: Simple and effective for signals with predictable patterns; adaptive versions can adjust to changing signal statistics.
  - *Disadvantages*: Can suffer from slope overload or granular noise if not adapted properly.
])

#info_box(title: "Transform Coding (DCT, Wavelets)", [
  - *Use Cases*: The basis for modern image (JPEG, JPEG 2000), video (MPEG, H.26x), and audio (MP3, AAC) compression.
  - *Advantages*: Excellent energy compaction, concentrating signal energy into a few coefficients. Closely related to the optimal KLT.
  - *Disadvantages*: Can introduce blocking artifacts at low bitrates (for DCT). Can be computationally complex.
])

#info_box(title: "Subband Coding", [
  - *Use Cases*: Digital audio (MP3, AAC), speech (G.722), and image (JPEG 2000) compression.
  - *Advantages*: Allows different frequency bands to be quantized and coded independently, enabling the use of psychoacoustic/psychovisual models for better perceptual quality.
  - *Disadvantages*: Requires careful design of filter banks to avoid aliasing and ensure perfect reconstruction.
])

#info_box(title: "Vector Quantization (VQ)", [
  - *Use Cases*: Speech, image, and video compression (e.g., CELP, G.719).
  - *Advantages*: More efficient than scalar quantization as it can exploit correlations between samples in a vector.
  - *Disadvantages*: Codebook design (LBG algorithm) and search can be computationally expensive. Tree-structured VQ (TSVQ) can speed up search at the cost of some quality.
])

#info_box(title: "Video Compression (MPEG, H.26x)", [
  - *Use Cases*: Streaming video, Blu-ray, digital television, videoconferencing.
  - *Advantages*: Achieves very high compression by exploiting both spatial redundancy (like JPEG) and temporal redundancy between frames (using motion compensation).
  - *Disadvantages*: Highly complex, requiring significant computational power for encoding.
])

#info_box(title: "Companding ($\mu$-law, A-law)", [
  - *Use Cases*: Telephony and speech signals (G.711 standard).
  - *Advantages*: Efficiently encodes speech with a good balance of dynamic range and resolution for voice frequencies, using a simple non-uniform quantization scheme.
  - *Disadvantages*: Specific to audio; introduces a non-linear distortion.
])
