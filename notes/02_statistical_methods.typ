#import "../definitions.typ": *

#pagebreak()

= Statistical Methods

== Basic Concepts

- *Alphabet*: A finite set of symbols, denoted by $A$.
- *String* (or message): A finite sequence of symbols from an alphabet $A$.
- *Length* of a string $s$: The number of symbols in the sequence, denoted by $|s|$.
- $A^*$ denotes the set of all possible strings over the alphabet $A$.

== Encoding

- *Encoding*: A function $f: A^* -> A_C^*$, where $A$ is the source alphabet and $A_C$ is the coding alphabet. We will use $A_C = {0, 1}$.
- *Uniquely decodable*: An encoding is uniquely decodable if the function $f$ is an injection.

=== Phrases
A common strategy for encoding is to factorize an input string $s$ into substrings called *phrases*.
$ s = s_1 s_2 ... s_k $
Each phrase $s_i$ is then encoded into a codeword $C(s_i)$. The final encoded string is the concatenation of these codewords.
$ f(s) = C(s_1)C(s_2)...C(s_k) $

For now, we focus on encodings where each phrase is a single symbol from the alphabet.

== Codes

- *Code*: A function $K: A -> A_C^*$ that assigns a codeword $K(s)$ to each symbol $s$ in the source alphabet $A$.
- *Generated Encoding*: A code $K$ generates an encoding $K^*$ by mapping a string of symbols to a concatenation of their corresponding codewords:
  $ K^*(s_1s_2...s_n) = K(s_1)K(s_2)...K(s_n) $
- A code $K$ is *uniquely decodable* if its generated encoding $K^*$ is uniquely decodable.

#task(title: "Uniquely Decodable Codes", [
  *Input*: A set of codewords for a source alphabet $A$. \
  *Question*: Does it define a uniquely decodable code?

  *Examples*:
  - `{0, 01, 11}`: Not uniquely decodable. The string "011" could be decoded as "0" + "11" or "01" + "1".
  - `{0, 01, 10}`: Uniquely decodable. No codeword is a prefix of another, and no concatenation of codewords can be misinterpreted.
])

== Prefix Codes
- *Prefix*: A string $s'$ is a prefix of a string $s$ if $s$ starts with $s'$.
- *Prefix Code*: A code where no codeword is a prefix of another codeword.

#observation(
  [
    Every prefix code can be represented by a binary tree, known as a *prefix tree*. This tree can be used for efficient decoding.
  ],
)

// #example_box(title: "Prefix Tree", [
//   #figure(
//     image("../images/prefix_tree_example.png", width: 50%),
//     caption: [An example of a prefix tree for a code.],
//   )
// ])

== Statistical Methods

The main idea behind statistical methods is that some symbols appear more frequently than others in a message. By assigning shorter codewords to more frequent symbols, we can achieve better compression. A historical example of this is the Morse code.

== Shannon-Fano Coding

The Shannon-Fano algorithm is one of the earliest methods for constructing a prefix code based on symbol frequencies.

#info_box(title: "Shannon-Fano Algorithm", [
  1. Sort the source alphabet symbols based on their frequencies in descending order.
  2. Divide the sorted sequence into two parts such that the sums of frequencies in both parts are as close as possible.
  3. Assign '0' as the prefix for codewords in the first part and '1' for those in the second part.
  4. Apply steps 2 and 3 recursively to each part until each part contains only a single symbol.
])

#example_box(title: "Shannon-Fano Example", [
  Let's consider an alphabet with the following frequencies:
  - a: 35
  - b: 17
  - c: 17
  - d: 16
  - e: 15

  The algorithm would proceed as follows, dividing the set of symbols and assigning prefixes:

  // #figure(
  //   image("../images/shannon_fano_example.png", width: 100%),
  //   caption: [Step-by-step construction of a Shannon-Fano code.],
  // )

  The resulting code is:
  - a: 00
  - b: 01
  - c: 10
  - d: 110
  - e: 111
])

== Optimal Codes

A prefix code is considered *optimal* if it provides the shortest possible encoded length for any string, given the symbol frequencies.

#observation(
  [
    The Shannon-Fano algorithm does not always produce an optimal code. An algorithm that does, known as Huffman coding, was developed by David Huffman in 1951.
  ],
)
