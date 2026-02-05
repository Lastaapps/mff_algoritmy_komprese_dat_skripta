#import "../definitions.typ": *

#pagebreak()

= Huffman Coding

== Introduction
Huffman coding, developed by David A. Huffman in 1951, is a popular algorithm for creating optimal prefix codes. Unlike Shannon-Fano coding, Huffman's algorithm guarantees the construction of a code with the minimum possible average codeword length.

== Algorithm
The Huffman algorithm builds a prefix tree from the bottom up, starting with the least frequent symbols.

#info_box(title: "Huffman Algorithm", [
  *Input*: An alphabet $A$ and the frequency $f(s)$ for each symbol $s$ in $A$. \
  *Output*: A prefix tree for $A$.

  1. Create a leaf node for each symbol and add it to a priority queue. The priority is determined by the frequency of the symbol, with lower frequencies having higher priority.
  2. While there is more than one node in the queue:
    - Extract the two nodes with the lowest frequencies (highest priorities) from the queue.
    - Create a new internal node with these two nodes as its children.
    - The frequency of this new node is the sum of the frequencies of its children.
    d. Add the new node back into the priority queue.
  3. The remaining node is the root of the Huffman tree.
])

#example_box(title: "Huffman Tree Construction", [
  Consider the alphabet {a, b, c, d, e, f} with frequencies {45, 13, 12, 16, 9, 5}.

  // #figure(
  //   image("../images/huffman_tree_construction.png", width: 100%),
  //   caption: [Step-by-step construction of a Huffman tree.],
  // )

  The final tree gives the following Huffman codes:
  - a: 0
  - b: 101
  - c: 100
  - d: 111
  - e: 1101
  - f: 1100
])

== Optimality of Huffman Codes
The optimality of Huffman coding is based on two key lemmas.

#lemma(title: "Lemma 1", [
  In an optimal prefix tree, symbols with the two lowest frequencies will be siblings at the maximum depth of the tree.
])

#lemma(title: "Lemma 2", [
  Let $x$ and $y$ be two symbols with the lowest frequencies. Let $A'$ be the alphabet $A$ with $x$ and $y$ replaced by a new symbol $z$ such that $f(z) = f(x) + f(y)$. If we have an optimal prefix tree for $A'$, we can construct an optimal prefix tree for $A$ by replacing the leaf node for $z$ with an internal node that has $x$ and $y$ as its children.
])

#theorem(title: "Optimality of Huffman Coding", [
  The Huffman algorithm produces an optimal prefix code. This means that no other prefix code can have a smaller average codeword length for the given symbol frequencies.
])

=== Kraft-McMillan Inequality
The Kraft-McMillan inequality provides a condition for the existence of a uniquely decodable code with given codeword lengths.

#theorem(title: "Kraft-McMillan Inequality", [
  For any uniquely decodable code, the codeword lengths $l_1, l_2, ..., l_n$ must satisfy the inequality:
  $ sum_(i=1)^n 2^(-l_i) <= 1 $
  Conversely, if a set of codeword lengths satisfies this inequality, a prefix code with these lengths exists.
])

#info_box(title: "Corollary", [
  Because Huffman coding produces a prefix code (which is inherently uniquely decodable) and is optimal in terms of average length, it also produces an optimal uniquely decodable code.
])

== Implementation Notes
- *Bitwise I/O*: For efficient storage, the output should be handled bit by bit, not character by character.
- *Overflow*: When summing frequencies to create parent nodes, be mindful of potential integer overflow if frequencies are large.
- *Code Reconstruction*: The Huffman tree (or a derived code table) is needed for both encoding and decoding. This structure must be stored or transmitted along with the compressed data.

== Problems

#task(title: "Minimizing Maximum Codeword Length", [
  *Question*: Can we modify the Huffman algorithm to guarantee that the resulting code minimizes the maximum codeword length? \
  *Solution*: Yes. When merging nodes, if there is a tie in frequencies, prioritize merging the nodes that are higher up in the tree (i.e., have a smaller depth). This tends to create more balanced trees, which helps in minimizing the maximum codeword length.
])

#task(title: "Maximum Height of a Huffman Tree", [
  *Question*: What is the maximum height of a Huffman tree for an input message of length $n$? \
  *Solution*: The maximum height of a Huffman tree occurs in the case of a skewed tree, which can happen with certain frequency distributions (e.g., Fibonacci-like sequences). For an alphabet of size $|A|$, the maximum height can be $|A|-1$.
])

#task(title: "Non-Huffman Optimal Codes", [
  *Question*: Is there an optimal prefix code which cannot be obtained using the Huffman algorithm? \
  *Solution*: Yes. Bijection and stuff. By Huffman code we consider code produced by the algorithm above, it cannot produce every optimal code. #strike[No. The Huffman algorithm is guaranteed to produce an optimal prefix code. Any other prefix code with the same average length is also optimal, but it can be shown that such codes can be transformed into a standard Huffman tree. For a given set of frequencies, while there might be multiple different optimal prefix codes (e.g., by swapping 0s and 1s), they all achieve the same minimum average codeword length, and at least one of them will be a Huffman code.]
])

#task(title: "M-ary Huffman Coding", [
  *Question*: Generalize the construction of binary Huffman code to the case of an m-ary coding alphabet (where $m > 2$). \
  *Solution*: The algorithm can be generalized. The core idea is to group the least frequent symbols together.
  1. At each step, instead of merging 2 nodes, we merge $m$ nodes.
  2. If the number of symbols minus 1 is not a multiple of $m-1$, dummy symbols with a frequency of 0 must be added until this condition is met. This ensures that the construction results in a full m-ary tree.
  3. The rest of the algorithm proceeds as usual: the $m$ nodes with the lowest frequencies are combined into a new parent node whose frequency is the sum of its children's frequencies.
])
