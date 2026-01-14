# Project: Data Compression Algorithms lecture notes

This project aims to create lecture notes for the "Data Compression Algorithms" course taught at the Faculty of Mathematics and Physics, Charles University in Prague (MFF CUNI).

## Goal

The primary goal is to produce high-quality lecture notes in English (B2 level) for each topic covered in the course.

## Project Structure

- `main.typ`: The main Typst file that combines all chapters.
- `definitions.typ`: Specifies common types of boxes and other common styling logic. This should be included in every file and boxes and other styles from this file should be used.
- `notes/`: This directory contains the individual chapter files in Typst format.
- `lectures/`: This directory contains the source PDF presentations for each lecture.

## Output Format

The final study materials will be written in [Typst](https://typst.app/), a modern typesetting system. Each lecture is converted into a single file, which are then included in the main document.

## How to create a new chapter

-  **Context:** Always read `./definitions.typ` before doing other tasks. Before starting to any kind of work/changes on a lecture, first read a corresponding lecture PDF file in context and stick to it as much as possible. No details from the PDF slide should be lost.
-  **Extract key concepts:** Identify and summarize the algorithms, data structures, compression algorithm, approaches and theoretical concepts from each presentation.
-  **Simplify:** Rewrite the extracted information in clear and concise B2 level English. Do not be too verbose.
-  **Structure the content:** Organize the material logically, suitable for study. Use subsections where necessary. Add examples (inspired by the original presentation) where needed.
-  **Theoretical completeness:** Make sure that all theorems, lemmas and observations are included and if the proof is provided, it is included as well.
-  **Add tasks:** Read the slides again. Find all slides whole title is "Problems". Make sure all the problems from these slides are included and solved.
-  **Format in Typst:** Create a `.typ` file for each topic in the `notes/` directory, formatting the content using Typst's syntax. Before writing, consult with the Typst rules listed bellow.

## Text format

- Format examples and explanations to a corresponding box so they do not disturb the main text information flow.
- Use bullet-point lists where possible, do not use long sentences.
- Exclude all the history related notes and benchmarks.
- Each chapter should start on a new page.
- When a Greek letter or match symbols should be used, use them as a proper symbols.
- Use math mode for math expressions and Greed letters (denoted by $$). Do not use escape mode ```` unless you escape words or algorithms.

## How Typst works

Important: NEVER EVER USE LaTeX expressions prefixed by backslash!!!
Never use backslashes, only for escaping!!!

### Typst specifics

- For bold text, use a single start `*bold text*`. For italics, use a single underscore `_italic text_`.
- For Greek letters math mode $ alpha $.
- Typst syntax and naming differs from LaTeX.
- Text in math mode is enclosed in double quotes e.g., `$ a "is substring of" b $`.

### Math Mode Variables and Subscripts

-   Variables in math mode should be directly written, e.g., $T$, $n$, $P$.
-   Multi-character subscripts or superscripts in math mode are enclosed in regular parentheses and followed by a space, e.g., `$h_("new") (x)$`, `$T^(T) dot A$`.

