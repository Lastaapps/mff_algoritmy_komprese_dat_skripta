#import "../definitions.typ": *

#pagebreak()

= Transform Coding

== The Transform Coding Scheme
Transform coding is a lossy compression technique that converts data from its spatial domain to a frequency domain, where it can be more efficiently compressed. The general process involves four main steps:

1. *Blocking*: The input signal (e.g., an image) is divided into small, non-overlapping blocks of a fixed size (e.g., $8 times 8$ pixels).
2. *Transformation*: A linear transform is applied to each block. This transform decorrelates the data and concentrates most of its energy into a few low-frequency coefficients.
3. *Quantization*: The resulting transform coefficients are quantized. This is the main lossy step, where high-frequency coefficients (which often represent less perceptible detail) are quantized more coarsely than low-frequency coefficients. Many high-frequency coefficients may become zero.
4. *Coding*: The quantized coefficients are then losslessly encoded using techniques like Huffman coding or arithmetic coding.

== Key Transforms

=== Orthogonal Transforms
An orthogonal transform has the property that its inverse is its transpose ($A^(-1) = A^T$). This simplifies computation and preserves the signal's energy. The goal of a transform is to achieve a high *transform gain* ($G_T$), which measures its ability to compact energy into a few coefficients.

=== Karhunen-Loève Transform (KLT)
The KLT is theoretically the optimal transform for energy compaction. Its transform matrix consists of the eigenvectors of the autocorrelation matrix of the source signal.
- *Problem*: The KLT is data-dependent and computationally expensive. The autocorrelation matrix changes with the input, requiring the transform to be constantly recomputed, which is impractical for most applications.

=== Discrete Cosine Transform (DCT)
The DCT is a fixed, data-independent transform that provides excellent energy compaction and is very close to the optimal KLT for highly correlated signals (like images). It has become the industry standard for image and video compression.
- *Why DCT is better than DFT (Discrete Fourier Transform)*: The DFT assumes the signal is periodic. When applied to a non-periodic block, it introduces sharp discontinuities at the block boundaries, spreading energy into high-frequency coefficients. The DCT, by mirroring the signal, avoids these discontinuities, leading to much better energy compaction.

=== Other Transforms
- *Discrete Sine Transform (DST)*: Similar to DCT, but better suited for sources with low correlation.
- *Discrete Walsh-Hadamard Transform (DWHT)*: Computationally very fast as it uses only additions and subtractions. However, its energy compaction is significantly worse than DCT.

== Quantization and Coding of Coefficients
After transformation, many coefficients (especially high-frequency ones) are small or zero.

- *Zonal Sampling*: Allocates bits to coefficients based on their expected variance. More bits are allocated to low-frequency coefficients and fewer or none to high-frequency ones. This is simple but not adaptive to the content of a specific block.
- *Threshold Coding*: Discards coefficients that fall below a certain threshold.
- *Zigzag Scan*: To capitalize on the large number of zero-valued high-frequency coefficients, the 2D block of quantized coefficients is scanned in a zigzag pattern. This groups the low-frequency coefficients at the beginning and creates long runs of zeros at the end, which can be efficiently compressed using run-length encoding (e.g., with a special End-of-Block (EOB) symbol).

== Application: JPEG
The JPEG (Joint Photographic Experts Group) standard is the most common application of transform coding.

#info_box(title: "JPEG Compression Pipeline", [
  1. *Color Space Transform*: The image is converted from RGB to YCbCr. The human eye is more sensitive to luminance (Y) than chrominance (Cb, Cr), so these components can be compressed more aggressively.
  2. *Chroma Subsampling*: The resolution of the Cb and Cr components is reduced (e.g., 4:2:2 or 4:2:0), saving significant space with little perceptible loss.
  3. *Blocking*: Each component is split into $8 times 8$ blocks.
  4. *DCT*: An $8 times 8$ DCT is applied to each block.
  5. *Quantization*: Each of the 64 DCT coefficients is divided by a corresponding value from a quantization table and rounded. Higher quantization values lead to more compression and lower quality.
  6. *Coding*:
    - The DC coefficient (the top-left, average value) is encoded differentially from the DC coefficient of the previous block.
    - The AC coefficients are scanned in a zigzag pattern and run-length encoded, then Huffman or arithmetic coded.
])

*Disadvantage*: At low bitrates, the block-based nature of JPEG can become visible as "blocking artifacts" or a "tile effect."

== Application: WebP
WebP is a modern image format developed by Google, designed to provide better compression than JPEG.
- It is a derivative of the VP8 video format.
- It uses the same YCbCr color space and chroma subsampling as JPEG.
- Instead of just DCT, it can use different prediction modes for macroblocks (H_PRED, V_PRED, DC_PRED) to exploit redundancy from neighboring blocks, similar to video compression.
- It uses an arithmetic coder for entropy coding.
