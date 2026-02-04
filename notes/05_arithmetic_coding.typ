#import "../definitions.typ": *

#pagebreak()

= Arithmetic Coding

== The Core Idea
Arithmetic coding is a powerful statistical compression method that encodes an entire message into a single number, specifically a fraction in the interval $[0, 1)$. Unlike Huffman coding, which assigns a fixed-length code to each symbol, arithmetic coding represents the message as a subinterval. The length of this subinterval is proportional to the probability of the message, allowing for more efficient compression, especially when probabilities are not powers of two.

The core idea is to:
1. Associate each possible message $s$ with a unique subinterval $I_s subset [0, 1)$.
2. Ensure that for different messages $s$ and $s'$, their corresponding intervals do not overlap ($I_s inter I_(s') = ø$).
3. The length of the interval $I_s$ should be equal to the probability of the message, $p(s)$.
4. The output code $C(s)$ is the shortest possible binary fraction that falls within the interval $I_s$.

To estimate the probability of a message $p(s_1 s_2 ... s_m)$, we often assume independence between symbols, leading to:
$ p(s_1 s_2 ... s_m) = p(s_1) p(s_2) ... p(s_m) $

== Encoding Process
The encoder starts with the interval $[0, 1)$ and progressively narrows it down for each symbol in the message.

#info_box(title: "Arithmetic Encoding Algorithm", [
  - Initialize `lower_bound` = 0 and `range` = 1.
  - For each `symbol` in the message:
    1. Update the `lower_bound`: `lower_bound` = `lower_bound` + `range` dot `symbol_lower_bound`.
    2. Narrow the `range`: `range` = `range` dot `symbol_probability`.
  - The final interval is [`lower_bound`, `lower_bound` + `range`).
  - Output a binary fraction that uniquely identifies this interval.
])

#example_box(title: "Encoding 'BILL'", [
  Assume the probabilities from the lecture slides.
  - Initial interval: $[0, 1)$
  - After 'B' (prob 0.1, range $[0.2, 0.3)$): New interval is $[0.2, 0.3)$.
  - After 'I' (prob 0.1, range $[0.5, 0.6)$ within the new context): The interval becomes $[0.2 + 0.1 * 0.5, 0.2 + 0.1 * 0.6) = [0.25, 0.26)$.
  - After 'L' (prob 0.2, range $[0.6, 0.8)$): The interval becomes $[0.25 + 0.01*0.6, 0.25 + 0.01*0.8) = [0.256, 0.258)$.
  - And so on...
])

== Decoding Process
The decoder reverses the process. It starts with the received fraction and, using the same probability model, determines which symbol corresponds to the interval the fraction falls into.

#info_box(title: "Arithmetic Decoding Algorithm", [
  - Read the encoded fraction `code`.
  - Repeat until the message is fully decoded:
    1. Find the symbol whose probability range contains the current value of `code`.
    2. Output this symbol.
    3. "Zoom in" on this symbol's interval:
      - Subtract the symbol's lower bound from `code`.
      - Divide `code` by the symbol's probability.
])

== Integer Arithmetic Implementation
Floating-point arithmetic is slow and can suffer from precision issues. In practice, arithmetic coding is implemented using integer arithmetic with fixed-size registers to represent the coding interval.

- Let `L` be the integer lower bound and `R` be the integer range. These represent the interval `[L, L+R)`.
- We use a fixed precision of `b` bits. The range `R` is initialized to the maximum possible value (`2^b - 1`). `L` is initialized to 0.

=== Encoding with Integers and Rescaling

The core idea is to maintain the interval `[L, L+R)` and rescale it whenever possible to prevent the range `R` from becoming too small and losing precision.

#info_box(title: "Integer Encoding Steps", [
  For each `symbol` in the message:
  1. *Update the interval*: The range `R` is partitioned according to the symbol probabilities.
    `L = L + R * symbol_lower_bound`
    `R = R * symbol_probability`
    (Note: these multiplications are integer operations, so proper scaling is needed, e.g., `(R * prob) / total_count`)

  2. *Rescale and Output Bits (Renormalization)*: As `L` and `L+R` are updated, their most significant bits may become the same. When this happens, we can output these bits and expand the interval to maintain precision. This is repeated until the interval is no longer in a state where bits can be output.

    - *E1 Condition*: If the entire interval `[L, L+R)` is in the lower half of the code space (e.g., both `L` and `L+R` are less than `2^(b-1)`), we can output a '0'. We then shift the interval to the left by one bit (`L = 2*L`, `R = 2*R`).

    - *E2 Condition*: If the interval is in the upper half (e.g., `L` is greater than or equal to `2^(b-1)`), we can output a '1'. We then shift the interval to the left, effectively moving it to the lower half for further processing (`L = 2*(L - 2^(b-1))`, `R = 2*R`).

    - *E3 Condition (Underflow)*: If the interval straddles the midpoint (e.g., `L < 2^(b-1)` and `L+R >= 2^(b-1)`), we cannot output a '0' or '1' yet. To prevent the range `R` from becoming too small, we expand the middle portion of the interval. We keep track of how many times this happens in an `underflow_counter`. The interval is updated as (`L = 2*(L - 2^(b-2))`, `R = 2*R`). When an E1 or E2 condition is eventually met, we output the corresponding bit followed by a sequence of opposite bits determined by the `underflow_counter`.
])

After processing all symbols, any pending underflow bits are flushed to the output stream to ensure the code is complete.

=== Decoding with Integers

The decoder mirrors the process, using the received bits to reconstruct the original interval narrowing sequence.

#info_box(title: "Integer Decoding Steps", [
  1. *Initialization*: Initialize `L`, `R` as in the encoder. Load the first `b` bits of the encoded stream into a variable `code`.

  2. *Symbol Identification*:
    - Use the current `code` value to find which symbol's sub-interval it falls into. This is done by scaling the `code` relative to the current interval `[L, R)`.
    - `current_value = ((code - L + 1) * total_count - 1) / R`
    - Find the symbol whose cumulative frequency range contains `current_value`.

  3. *Output and Update*:
    - Output the identified symbol.
    - Update `L` and `R` to match the sub-interval of the decoded symbol, just as in the encoding process.

  4. *Rescale and Input Bits*:
    - Use the same E1, E2, and E3 conditions as the encoder to rescale the interval `[L, R)`.
    - When rescaling occurs (e.g., after an E1 or E2 condition), a bit is shifted out of `L` and `R`, and a new bit is shifted in from the encoded input stream to update `code`. This keeps the `code` value aligned with the decoder's current position in the compressed data.
])

== Adaptive Arithmetic Coding
Arithmetic coding can be made adaptive, just like Huffman coding. This is typically done by using a frequency table that is updated after each symbol is processed.

- To efficiently find the symbol corresponding to a given value, and to calculate cumulative frequencies, a data structure is needed.
- A *Fenwick tree* (or Binary Indexed Tree) is an excellent choice for this. It allows for both point updates and prefix sum queries in $O(log n)$ time, where $n$ is the alphabet size.
- This makes the decoding process much faster than a linear scan of the frequency table, bringing the complexity down to $O(n + c + m * log n)$.

== Precision and Complexity
- *Precision Loss*: Using integer arithmetic introduces small roundoff errors, which can slightly increase the code length. However, with a sufficient number of bits for precision (e.g., b=32, f=24), the average code length increase is negligible (< 0.01 bit/symbol).
- *Time Complexity*:
  - *Encoding*: $O(n + c + m)$, where c is the output code length in bits.
  - *Decoding*: With a Fenwick tree, it becomes $O(n + c + m * log n)$.
  - The use of an implicit tree can further improve decoding time.
