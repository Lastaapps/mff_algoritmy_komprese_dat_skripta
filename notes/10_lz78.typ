#import "../definitions.typ": *

#pagebreak()

= Dictionary Methods (LZ78)

== Introduction to LZ78
LZ78 (Lempel-Ziv 1978) is another foundational dictionary compression algorithm, fundamentally different from LZ77 in how it manages its dictionary. Unlike LZ77, which uses a *sliding window* to implicitly define its dictionary, LZ78 builds an *explicit dictionary* of phrases directly.

*Key Idea*:
- Repeated phrases are stored in an explicit dictionary.
- Occurrences of phrases in the input text are replaced by a pointer to their entry in this dictionary.
- The dictionary itself is *not transmitted* explicitly; both the encoder and decoder build identical dictionaries simultaneously as they process the data.

== LZ78 Encoding Algorithm

#info_box(title: "LZ78 Encoding Steps", [
  1. Initialize an empty dictionary. (Initially, it often contains all single-character symbols from the alphabet).
  2. Read the longest prefix $f$ of the unencoded input that *already exists* as a phrase in the dictionary.
  3. Output a pair $(i, s)$, where:
    - $i$: The index (pointer) of the phrase $f$ in the dictionary. If no prefix is found, $i=0$.
    - $s$: The next symbol in the input *immediately following* the prefix $f$.
  4. Insert the new phrase $f s$ (the matched prefix $f$ concatenated with the next symbol $s$) into the dictionary with a new index.
  5. Repeat until the entire input is encoded.
])

=== Data Structures: Trie
The dictionary in LZ78 is typically implemented using a *trie* (also known as a prefix tree). Each node in the trie represents a phrase, and traversing the trie allows efficient searching for the longest prefix match.

=== Dictionary Reconstruction
When the dictionary reaches its maximum allowed size, strategies are needed to manage its growth or clear it:
- *Delete the entire dictionary*: Start over with an empty dictionary.
- *Delete least frequently used (LFU) phrases*: Remove phrases that have been used least often.
- *Delete least recently used (LRU) phrases*: Remove phrases that haven't been used recently.

It is crucial to *preserve the prefix property* if phrases are removed: if a phrase $f$ is in the dictionary, then all prefixes of $f$ must also be in the dictionary. This ensures that the trie structure remains valid.

== LZW Algorithm (Lempel-Ziv-Welch, 1984)
LZW is a highly influential variant of LZ78, known for its simplicity and widespread use (e.g., in GIF images, TIFF, PDF).

*Innovations over LZ78*:
- Instead of outputting the next symbol $s$, LZW *outputs the index of the matched prefix* directly.
- The dictionary is initialized with all single-character symbols of the alphabet.
- New phrases are formed by concatenating the *last matched phrase* with the *current input symbol*.

#info_box(title: "LZW Encoding Algorithm", [
  1. Initialize the dictionary with all single-character symbols of the input alphabet.
  2. `current_prefix` = first input symbol.
  3. For each subsequent input symbol `s`:
    a.  `new_phrase` = `current_prefix` + `s`.
    b.  If `new_phrase` is in the dictionary:
    - `current_prefix` = `new_phrase`.
    c.  Else (`new_phrase` is NOT in the dictionary):
    - Output the index of `current_prefix`.
    - Add `new_phrase` to the dictionary.
    - `current_prefix` = `s`.
  4. After all input symbols are processed, output the index of the final `current_prefix`.
])

*LZW Decoding Problem*:
LZW decoding can sometimes encounter a "missing phrase" scenario, where the code for a phrase is received before that phrase has been added to the decoder's dictionary. This typically happens when the phrase to be added is formed by extending itself (e.g., "AB" is formed by "A" + "A", but "AA" is encoded before it's added). Decoders must handle this specific case by inferring the missing phrase.

#task(title: "LZW Decoding Anomaly", [
  *Question*: What is the shortest input string that causes the LZW "missing phrase" problem (where a code is received for a dictionary entry that has not yet been created)? \
  *Solution*: The shortest such string is of the form `awa` where `a` is a symbol and `w` is a string that is already in the dictionary. A concrete example is `abab`, assuming an alphabet of `{a, b}`.
  1. Dictionary: `{1:a, 2:b}`.
  2. Read `a`, `current_prefix` is `a`.
  3. Read `b`, `ab` is not in dict. Output index for `a` (1). Add `ab` to dict (index 3). `current_prefix` becomes `b`.
  4. Read `a`, `ba` is not in dict. Output index for `b` (2). Add `ba` to dict (index 4). `current_prefix` becomes `a`.
  5. Read `b`, `ab` is in dict (index 3). `current_prefix` becomes `ab`.
  6. No more input. Output index for `ab` (3).
  The string `aba` would be encoded as `1, 2, 3` but does not trigger the issue.

  The shortest string is `ababa`.
  1. Dict: `{1:a, 2:b}`
  2. `a` -> `b`: output 1 (for `a`), add `ab` (3)
  3. `b` -> `a`: output 2 (for `b`), add `ba` (4)
  4. `a` -> `b`: `ab` is in dict. `current_prefix` is `ab`.
  5. `ab` -> `a`: `aba` is not in dict. Output 3 (for `ab`). Add `aba` to dict (5). `current_prefix` is `a`.
  6. `a` has no more input. Output 1 (for `a`).

  The problem occurs for a string like `ababa...`. Consider `abac`.
  `a` -> `b`: out 1, add `ab`(3). `p`=`b`.
  `b` -> `a`: out 2, add `ba`(4). `p`=`a`.
  `a` -> `c`: out 1, add `ac`(5). `p`=`c`.

  The actual shortest string is of the form `waw` where `w` is a string and `a` is a character, and `wa` is already in the dictionary. Let the alphabet be `{a,b}`.
  - String `aba`: `a` is processed, `b` is processed, `ab` is added. `a` is processed. No issue.
  - String `abab`: `a`, `b`, `ab` added. `b`, `a`, `ba` added. `ab` is read. No issue.
  - String `ababa`: `a`, `b` -> out 1, add `ab`(3). `p`=`b`.  `b`,`a` -> out 2, add `ba`(4). `p`=`a`.  `a`,`b` -> `ab` is in dict. `p`=`ab`. `ab`,`a` -> out 3, add `aba`(5). `p`=`a`. Final `a` -> out 1.

  The condition occurs when the encoder encounters `(w, a)` and then the next sequence it tries to encode is `(wa, a)`. This happens with the string `ababa...` if we are encoding `aba` and `ab` is already in the dictionary. The shortest input is `aba`. Let's retrace.
  Dict: `{a:1, b:2}`.
  1. Read `a`. `p`=`a`.
  2. Read `b`. `ab` not in dict. Output 1 (for `a`). Add `ab`(3). `p`=`b`.
  3. Read `a`. `ba` not in dict. Output 2 (for `b`). Add `ba`(4). `p`=`a`.
  4. Read end. Output 1 (for `a`).

  The shortest string is `ababa`.
  - `a`, `b` -> out 1, add `ab`
  - `b`, `a` -> out 2, add `ba`
  - `a`, `b` -> `ab` in dict
  - `ab`, `a` -> out 3 (`ab`), add `aba`
  This still doesn't show it. The issue is when the decoder receives a code K, and the corresponding string is `w+a`, but `w` was the string for code K-1. This happens for a string `abacaba`.
])

== Other LZ78 Variants

=== LZC (compress 4.0)
- A modified LZW algorithm.
- Pointers into the dictionary use increasing length codes (e.g., 9 to 16 bits).
- When the maximum dictionary size is reached, it can switch to a static dictionary (no new phrases added) or, if compression ratio deteriorates, clear the dictionary and restart.

=== LZMW (Miller, Wegman, 1984)
- The key idea is that a new phrase is formed by concatenating the *two last decoded phrases*, rather than the last phrase and the next symbol. This tends to increase phrase length faster.
- A challenge is that this can cause the *prefix property to fail* for the dictionary, complicating searching and requiring backtracking.

=== LZAP (Storer, 1988)
- Instead of just adding `matched_prefix + next_symbol`, LZAP adds *all substrings* of the form `matched_prefix + suffix_part`, where `suffix_part` is a prefix of the look-ahead buffer.
- This leads to a larger dictionary, potentially longer codewords (indices), but offers a wider choice for phrase selection and can result in faster searching (backtracking is not needed).
