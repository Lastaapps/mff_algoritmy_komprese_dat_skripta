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
Floating-point arithmetic is slow and can suffer from precision issues. In practice, arithmetic coding is implemented using integer arithmetic on fixed-size registers.

- The interval is represented by a `lower_bound` (L) and a `range` (R).
- These integers are mapped to the $[0, 1)$ interval.
- As the range R becomes smaller, the most significant bits of L and the new L+R will be the same. These bits can be output, and the interval can be rescaled (expanded) to maintain precision. This process is called *renormalization*.

Three types of interval expansion can occur:
- *E1*: The interval is entirely within the lower half, $[0, 0.5)$. Output a '0' and expand the interval.
- *E2*: The interval is entirely within the upper half, $[0.5, 1)$. Output a '1' and expand the interval.
- *E3*: The interval is straddling the midpoint, e.g., in $[0.25, 0.75)$. We cannot output a bit yet. A counter is used to track these "underflow" bits, which are resolved later.

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
