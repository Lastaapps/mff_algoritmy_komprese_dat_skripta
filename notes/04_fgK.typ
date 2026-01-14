#import "../definitions.typ": *

#pagebreak()

= Adaptive Huffman Coding

== Static vs. Adaptive Models
In data compression, we can distinguish between two main approaches for modeling the data:

- *Static Model*: The model is fixed before compression begins. This approach requires two passes over the data: one to gather statistics (like symbol frequencies) and build the model, and a second pass to encode the data. The model itself must also be transmitted to the decoder.

- *Adaptive Model*: The model is updated dynamically as the data is being processed. This allows for one-pass compression and decompression. The model does not need to be transmitted, as both the encoder and decoder can build it in the same way.

== Adaptive Huffman Coding
Adaptive Huffman coding is a method that updates the Huffman tree on the fly as each symbol is processed. This avoids the need for a pre-scan of the data and allows the coding to adapt to changing patterns in the input stream.

The general process for both encoding and decoding is as follows:
1. Initialize a Huffman tree.
2. For each symbol in the input:
  - Encode or decode the symbol using the current tree.
  - Update the tree based on the new symbol.

A brute-force approach of rebuilding the tree after every symbol is inefficient. The FGK algorithm provides an elegant solution.

== The Sibling Property and the FGK Algorithm
The FGK (Faller-Gallager-Knuth) algorithm is an efficient method for maintaining a valid Huffman tree. It is based on the *sibling property*.

#theorem(title: "The Sibling Property (Faller, 1973)", [
  A binary tree with non-negative vertex weights is a Huffman tree if and only if it has the sibling property. A tree has this property if:
  1. For every parent node, its weight is the sum of the weights of its children.
  2. Every node, except the root, has a sibling.
  3. The nodes can be listed in order of non-increasing weight, with each node being adjacent to its sibling.
])

The FGK algorithm maintains this property by performing local adjustments to the tree after each symbol is processed.

== Handling New Symbols: The Zero-Frequency Problem
A key challenge in adaptive coding is how to handle symbols that have not been seen before (i.e., have a frequency of zero). The FGK algorithm solves this using a special `esc` (escape) symbol.

#info_box(title: "The `esc` Symbol", [
  - The Huffman tree is initialized with a special `esc` symbol, which has a weight of 0.
  - When a new, previously unseen symbol `s` is encountered:
    1. The `esc` symbol's code is transmitted.
    2. The raw representation of the new symbol `s` is transmitted.
    3. A new leaf node for `s` (with a weight of 1) and a new `esc` node (with a weight of 0) are added to the tree.
])

== The Update Procedure
After a symbol `s` is processed (either encoded or decoded), its frequency increases by one. The FGK algorithm updates the tree to maintain the sibling property.

#info_box(title: "FGK Update Procedure", [
  1. Find the leaf node `v` corresponding to the current symbol `s`.
  2. Increment the weight of `v` and all its parent nodes.
  3. Starting from `v`, move up towards the root. At each level, check if the sibling property is violated (i.e., if a node's weight is greater than the weight of the next node in the sequence). If it is, swap the node with the highest-ordered node of the same weight to restore the property.
])

== Encoding and Decoding with FGK

=== Encoding
1. Initialize the Huffman tree with just the `esc` symbol.
2. For each symbol `s` in the input:
  - If `s` is new, write the code for `esc`, followed by the raw symbol `s`.
  - Otherwise, write the code for `s`.
  - Update the tree with `s` using the FGK update procedure.

=== Decoding
1. Initialize the Huffman tree with just the `esc` symbol.
2. Repeat until the end of the input stream:
  - Read bits from the input and traverse the tree until a leaf is reached.
  - If the leaf is the `esc` symbol, read the next few bits to determine the raw new symbol `s`.
  - Otherwise, the leaf's symbol is `s`.
  - Output `s` and update the tree with `s` using the FGK update procedure.

== Implementation Considerations

- *Overflow Problem*: As frequencies increase, the weights in the tree can become very large, leading to potential overflow. A common solution is to periodically scale down all weights by a constant factor (e.g., divide by 2) when the root's weight reaches a certain threshold. This "aging" process gives more importance to recent statistics.
- *Statistics Aging*: Another approach to keep frequencies relevant is to multiply all frequencies by a factor slightly less than 1 at each step. This gives exponentially less weight to older symbols.

The average codeword length of FGK is proven to be close to that of the optimal static Huffman code, specifically $l_("FGK") <= l_("H") + O(1)$.
