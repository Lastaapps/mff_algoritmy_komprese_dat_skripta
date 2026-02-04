#import "../definitions.typ": *

#pagebreak()

= Integer Coding

Integer coding refers to various methods for encoding positive integers into binary strings. These codes are often used as building blocks in more complex compression algorithms, particularly for encoding lengths, frequencies, or differences.

== Unary Code
The unary code is a simple and intuitive way to encode positive integers.

#info_box(title: "Unary Code $alpha$", [
  For a positive integer $i$, its unary code $alpha(i)$ is represented by $i-1$ ones followed by a zero.
  - $alpha(1) = 0$
  - $alpha(2) = 10$
  - $alpha(3) = 110$

  *Properties*:
  - The length of $alpha(i)$ is $| alpha(i) | = i$.
  - It is a prefix code.
])

=== Optimal Unary Code Distribution
The unary code is optimal for a probability distribution where $P(i) = (1/2)^i$ for $i = 1, 2, ...$.

== Binary Code
The standard binary representation of an integer.

#info_box(title: "Binary Code $beta$", [
  For a positive integer $i$, its binary code $beta(i)$ is its standard binary representation.
  - $beta(1) = 1$
  - $beta(2) = 10$
  - $beta(3) = 11$

  *Properties*:
  - The length of $beta(i)$ is $| beta(i) | = floor(log_2 i) + 1$.
  - It is *not* a prefix code (e.g., $beta(1) = 1$ is a prefix of $beta(3) = 11$).
])

=== Fixed Length Binary Code
A fixed length binary code is used when the alphabet size $n$ is known in advance and is typically a power of 2.

#info_box(title: "Fixed Length Binary Code", [
  For an alphabet of size $n$, each symbol is encoded using $ceil(log_2 n)$ bits.
  - This results in fixed-length codewords.
  - Optimal when all symbols are equiprobable ($P(i) = 1/n$).
  - However, it becomes less efficient if $n$ is not a power of 2, as some codewords might be unused.
])

=== Minimal Binary Code $beta_n$
When the alphabet size $n$ is not a power of 2, a minimal binary code can be constructed to minimize the average codeword length while maintaining fixed length for most symbols.

#info_box(title: "Minimal Binary Code $beta_n$", [
  Let $n$ be the alphabet size, and let $k = ceil(log_2 n)$.
  - For integers $i < 2^k - n$, use a $(k-1)$-bit binary code.
  - For other integers, use a $k$-bit binary code of $i + (2^k - n)$.
  This effectively assigns shorter codes to the first $2^k-n$ symbols, reducing the average length.
])

== Elias Codes: An Elegant Compromise
Peter Elias (1975) developed a family of universal codes that are efficient for encoding integers without prior knowledge of their probability distribution. These codes achieve a compromise between the unary and binary codes, using prefix coding.

=== Reduced Binary Code $beta'$
The reduced binary code $beta'(i)$ is the standard binary code $beta(i)$ without its most significant bit.
- $| beta'(i) | = floor(log_2 i)$.

=== Elias Gamma Code $gamma(i)$
The Elias Gamma code for an integer $i$ is formed by concatenating the unary code of its length (of $beta(i)$) and its reduced binary code.

#info_box(title: "Elias Gamma Code $gamma(i)$", [
  For an integer $i$:
  1. Let $L = floor(log_2 i)$ be the length of $beta'(i)$.
  2. The code is $alpha(L+1) dot beta'(i)$.
  - $gamma(i) = alpha(floor(log_2 i) + 1) dot beta'(i)$
  - The length is $| gamma(i) | = 2 dot floor(log_2 i) + 1$.
  - Example: $gamma(5) = alpha(3) dot beta'(5) = 110 dot 01 = 11001$.

  *Properties*:
  - It is a prefix code.
  - The length is approximately $2 dot log_2 i$.
])

=== Elias Delta Code $delta(i)$
The Elias Delta code is a further refinement that uses a shorter encoding for the length component.

#info_box(title: "Elias Delta Code $delta(i)$", [
  For an integer $i$:
  1. Let $L = floor(log_2 i) + 1$ be the length of $beta(i)$.
  2. The code is $gamma(L) dot beta'(i)$.
  - The length is $| delta(i) | = |gamma(L)| + |beta'(i)| = (2 floor(log_2 L) + 1) + (floor(log_2 i)) = 2 floor(log_2(floor(log_2 i) + 1)) + floor(log_2 i) + 1$.
  - Example: $delta(5)$:
    - $i=5$, $beta(5)=101$, $L=3$, $beta'(5)=01$.
    - We need $gamma(L) = gamma(3)$.
    - To get $gamma(3)$: $beta(3)=11$, length is 2. The code is $alpha(2) dot beta'(3) = 10 dot 1 = 101$.
    - So, $delta(5) = gamma(3) dot beta'(5) = 101 dot 01 = 10101$.

  *Properties*:
  - It is a prefix code.
  - The length is approximately $log_2 i + 2 log_2(log_2 i)$. It is shorter than Gamma for larger $i$.
])

=== Universality of Elias Codes
Elias codes are *universal* codes. This means that if the true probability distribution $P(i)$ decreases polynomially fast (e.g., $P(i) approx 1/i^k$), then the average codeword length produced by Elias codes will be asymptotically optimal, even if the exact distribution is unknown.
