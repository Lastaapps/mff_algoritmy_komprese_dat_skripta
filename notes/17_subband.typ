#import "../definitions.typ": *

#pagebreak()

= Subband Coding

== Introduction
Subband coding is a lossy compression technique that decomposes a signal into several frequency bands (subbands) and then encodes each band independently. This approach is powerful because it allows the quantization and coding strategy to be tailored to the specific characteristics of each frequency band.

*Motivation*:
While differential coding is effective for signals with high sample-to-sample correlation, it struggles with signals that have rapid local variations but slow long-term trends. Subband coding addresses this by separating the "slow trend" (low-frequency components) from the "rapid variation" (high-frequency components).

== Digital Filters
The core of subband coding is the use of digital filters to separate the frequency components.

- *Low-pass filter*: Allows components below a certain cutoff frequency to pass through, smoothing out the signal.
- *High-pass filter*: Allows components above a cutoff frequency to pass through, capturing the "detail" or "difference" part of the signal.
- *Filter Bank*: A cascade of filters used to decompose the signal into multiple subbands.

A common and efficient type of filter used in filter banks is the *Quadrature Mirror Filter (QMF)*. In a QMF pair, the impulse response of the high-pass filter is derived directly from the low-pass filter, ensuring that the two filters are perfectly complementary for reconstruction.

== The Subband Coding Algorithm
The process involves an analysis stage (decomposition) and a synthesis stage (reconstruction).

#info_box(title: "Basic Subband Coding Algorithm", [
  1. *Analysis (Decomposition)*:
    - The input signal is passed through a bank of analysis filters (e.g., a low-pass and a high-pass filter).
    - This splits the signal into multiple subband signals.

  2. *Downsampling (Decimation)*:
    - Since each subband now occupies a fraction of the original signal's bandwidth, its sampling rate can be reduced according to the Nyquist theorem.
    - For a two-band split, each subband signal can be downsampled by a factor of 2 (i.e., keeping every other sample).

  3. *Quantization and Coding*:
    - Each subband is quantized and encoded separately. This is a key advantage, as different bit allocations and coding schemes can be used for each band.
    - For example, more bits can be allocated to perceptually important low-frequency bands, while fewer bits are used for less important high-frequency bands.
    - Common encoding schemes for the quantized subbands include ADPCM and Vector Quantization.

  4. *Synthesis (Reconstruction)*:
    - The encoded subbands are decoded.
    - Each subband signal is *upsampled* by inserting zeros to restore its original sampling rate.
    - The upsampled signals are passed through a bank of synthesis filters (which are complementary to the analysis filters) and summed to reconstruct the original signal.
])

== Bit Allocation
A crucial part of subband coding is deciding how to distribute the available bits among the different subbands. A common heuristic is to allocate bits based on the variance of each subband: bands with higher variance (more information) receive more bits.

== Applications

=== G.722 (Speech Coding)
G.722 is an ITU-T standard for wideband speech coding (e.g., for VoIP).
- It splits the signal into two subbands (0-4kHz and 4-7kHz) using QMF filters.
- Each subband is then encoded using ADPCM, with more bits allocated to the more critical low-frequency band.

=== MPEG Audio (e.g., MP3)
MPEG (Moving Picture Experts Group) audio standards are a prime example of subband coding.
- *Decomposition*: The signal is split into 32 subbands using a QMF filter bank. In Layer 3 (MP3), a Modified DCT is also applied to further increase frequency resolution.
- *Psychoacoustic Model*: The key to MPEG's high compression ratio is the use of a psychoacoustic model. This model analyzes the signal to determine which frequency components are perceptually less important and can be quantized more aggressively. It leverages two main principles:
  - *Audibility Threshold*: Sounds below a certain loudness level at a given frequency are inaudible.
  - *Masking (Spectral and Temporal)*: A loud sound at one frequency can make nearby (in frequency or time) quieter sounds inaudible.
- *Quantization and Coding*: The psychoacoustic model determines the bit allocation for each subband. The quantized coefficients are then Huffman coded.

=== JPEG 2000 (Image Compression)
Subband coding is also used for image compression.
- The decomposition is done in 2D by applying filters separately to the rows and columns of the image. This typically results in four sub-images: LL (low-low frequency), LH, HL, and HH.
- The process can be applied recursively to the LL sub-image to create a multi-resolution representation.
- *Wavelet transforms* are a sophisticated form of subband filtering used in JPEG 2000. They provide excellent energy compaction and allow for features like progressive transmission and region-of-interest coding.

== Problems

#task(title: "The Downsampling Solution", [
  *Problem*: When a signal is split into a low-pass band ${y_(n)}$ and a high-pass band ${z_n}$, we have twice as many total samples as the original signal ${x_n}$. How is this addressed to achieve compression? \
  *Solution*: This is solved by *downsampling* (also called decimation). Since the low-pass and high-pass filters each halve the signal's bandwidth, the Nyquist theorem allows us to discard every other sample from both ${y_n}$ and ${z_n}$ without losing information from that band. The two resulting half-length signals ($y_(2n)$ and $z_(2n)$) together have the same number of samples as the original signal. The signal can be perfectly reconstructed from these downsampled signals during synthesis.
])

#task(title: "Huffman Coding over Extended Alphabets", [
  *Question*: Derive the lower and upper bounds on the average codeword length for the Huffman code over an alphabet extended to n-grams (blocks of n symbols). Assume symbols are independent and have the same entropy H. \
  *Solution*:
  - Let the original alphabet be $A$ with entropy $H$.
  - The extended alphabet $A^n$ consists of all possible n-grams. The entropy of this extended source, due to the independence of symbols, is $H(A^n) = n dot H(A)$.
  - Let $L_n$ be the average codeword length for the Huffman code over the extended alphabet $A^n$.
  - According to Shannon's source coding theorem, the average length is bounded by the entropy of the source. For the n-gram source, this gives:
    $ H(A^n) <= L_n < H(A^n) + 1 $
  - Substituting $H(A^n) = n H(A)$:
    $ n H(A) <= L_n < n H(A) + 1 $
  - The average codeword length *per original symbol* is $L_n / n$. Dividing the inequality by $n$:
    $ H(A) <= L_n/n < H(A) + 1/n $
  - As $n -> infinity$, the term $1/n -> 0$. This shows that by encoding larger and larger blocks (n-grams), the average number of bits per original symbol can be made to approach the entropy $H(A)$, which is the theoretical limit of compression.
])
