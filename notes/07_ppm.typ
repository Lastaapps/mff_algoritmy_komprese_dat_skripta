#import "../definitions.typ": *

#pagebreak()

= Context Methods (PPM)

== Data Compression: Two Stages
Data compression can generally be divided into two main stages:
1. *Modeling*: This stage involves analyzing the input data to build a statistical model that estimates the probability of encountering each symbol.
2. *Coding*: This stage uses the probabilities provided by the model to assign codewords to symbols. More probable symbols get shorter codewords, and less probable ones get longer codewords. Arithmetic coding is often used for this stage in context-based compressors.

=== Zero-Order Model
The simplest statistical model is the zero-order model, where the probability of a symbol depends only on its individual frequency, with no consideration for adjacent symbols or context. This implies no correlation between adjacent symbols.

== Finite Context Methods
Finite context methods improve upon zero-order models by recognizing that the probability of a symbol often depends on the symbols that precede it.

- The probability of a symbol is determined not only by its frequency but also by the *context* in which it has occurred.
- These methods are particularly effective for text compression, where language exhibits strong contextual dependencies.
- A "model of order $i$" utilizes contexts of length $i$ (i.e., the $i$ preceding symbols) to predict the next symbol.

=== Methods for Context Handling
- *Fixed Length Contexts*: Use a single, predefined context length (e.g., always consider the last 3 symbols).
- *Combined Contexts*: Use contexts of various lengths, often combining predictions from different orders.
  - *Complete*: Considers all contexts of lengths $i, i-1, ..., 0$.
  - *Partial*: Considers only a subset of these contexts.
- These methods can be either static or adaptive.

== Prediction by Partial Matching (PPM)
PPM is a widely used context-based compression algorithm that combines context modeling with arithmetic coding. It was introduced by Cleary and Witten (1984) and refined by Moffat (1990).

#info_box(title: "PPM Core Idea", [
  Given a symbol $s$ and its context $c$, PPM determines the frequency of $s$ in that specific context $c$. This frequency is then used by an arithmetic coder to encode the symbol.
])

=== PPM Encoding
To encode a symbol $s$ in a given context $c$ of length $i$:

1. Look up the context $c$ in the model.
2. If the symbol $s$ has been observed in context $c$ before (i.e., its frequency $f(s|c) > 0$):
  - Encode $s$ using the frequency information for $s$ in context $c$.
3. If $s$ has *not* been observed in context $c$:
  - Output an `ESC` (escape) symbol's code. This signals to the decoder that the current context cannot predict the symbol.
  - Try to encode $s$ in a shorter context (order $i-1$). This process continues, reducing the context length, until $s$ is found or the order 0 (empty context) is reached. If not found even in order 0, it may fall back to transmitting the raw symbol.

A necessary assumption for this process to work is that there must be an order $i$ (possibly 0) where the frequency of $s$ in context $c$ is defined.

=== Handling Escape Probabilities: PPM Variants
The way the probability of the `ESC` symbol is calculated is crucial for PPM's performance and differentiates various PPM variants.

- *PPMA (Cleary, Witten)*:
  - If a context $c$ has $n$ unique symbols that satisfy $f(x|c)>0$, then $P("esc"|c) = 1 / (n+1)$.
- *PPMB (Cleary, Witten)*:
  - $P("esc"|c) = "number of unique symbols seen in context" c " only once" / "total number of symbols seen in context" c$.
- *PPMC (Moffat)*:
  - $P("esc"|c) = |\{x | f(x|c)>0 \}| / (n + |\{x | f(x|c)>0 \}|)$, where $n$ is the total count of symbols in context $c$.
- *PPMD (P.G.Howard, J.Vitter)*:
  - Assigns a weight of 1/2 to the first occurrence of any symbol and a weight of 1 to subsequent occurrences.

== Data Structures: Context Tree (Trie)
To efficiently store and access contexts and their associated frequencies, a *context tree* or *trie* is used.

- Each node in the trie represents a context.
- Edges from a node represent symbols that follow that context.
- The depth of a node indicates the order of the context.
- Frequencies for symbols within each context are stored at the nodes.

#example_box(title: "Context Tree Example", [
  Imagine contexts built from the string "assan".
  - The root represents the empty context (order 0).
  - A child node for 'a' represents context "a".
  - From "a", a child for 's' represents context "as", and so on.
  As new symbols are encountered, new nodes and paths are added to the trie, and frequencies are updated.
])

== Space Limitations
Context models, especially for higher orders, can consume a significant amount of memory. Strategies to manage this include:

- *Freezing the Model*: If memory usage exceeds a threshold, stop adding new contexts and only update frequencies for existing ones. Ignore new contexts.
- *Rebuilding the Model*: If compression performance degrades (e.g., the compression ratio starts decreasing), rebuild the model from scratch, possibly with a buffered history of recent symbols.
- *Advanced Data Structures*: Using structures like a *Directed Acyclic Word Graph (DAWG)* can help by identifying and merging equivalent contexts, thus reducing memory overhead compared to a pure trie.

== Other Modifications
PPM has seen numerous modifications and improvements over the years, including:
- *PPMII (D.Škarin, 2002)*: Introduced concepts like information inheritance (contexts inheriting statistics from their ancestors), multiple context classes, and frequency scaling.
- *PAQ series (Matt Mahoney)*: Advanced compressors that heavily utilize context mixing, combining predictions from a multitude of different context models using weighted averages.

These advancements demonstrate the continuous effort to optimize PPM-based compression by refining context modeling, probability estimation, and memory management.
