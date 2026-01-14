#import "definitions.typ": *

#set document(
  title: "Data Compression Algorithms",
  author: "Petr Laštovička, Gemini",
)
#set text(lang: "en")

#show outline.entry.where(
  level: 1,
): it => {
  v(1em)
  strong(it)
}


#include "title.typ"

#align(center)[
  This material is meant as a supplement to the presentations provided.
  There may be some divergence from the slides, some problems or lemmas may be missing.
  Still, I find it a great source to understand the topic,
  while the details for the exam should be learned from the slides.

  The lecture notes start with overview, continue with lectures numbered the same way
  as in the subject slides. Lastly, set of exam tasks is added and solved.
]
#pagebreak()

#outline(title: "Table of Contents", depth: 2)
#pagebreak()

#include "notes/overview.typ"

#set heading(numbering: "1.1.")

#include "notes/01_intro.typ"
#include "notes/02_statistical_methods.typ"
#include "notes/03_huffman.typ"
#include "notes/04_fgK.typ"
#include "notes/05_arithmetic_coding.typ"
#include "notes/06_information.typ"
#include "notes/07_ppm.typ"
#include "notes/08_integer_coding.typ"
#include "notes/09_lz77.typ"
#include "notes/10_lz78.typ"
#include "notes/11_lossless_image_compression.typ"
#include "notes/12_bwt.typ"
#include "notes/13_lossy_intro.typ"
#include "notes/14_vector_quantization.typ"
#include "notes/15_differential.typ"
#include "notes/16_transform.typ"
#include "notes/17_subband.typ"
#include "notes/18_video.typ"

#set heading(numbering: "A.1")
#counter(heading).update(0)

// #include "notes/exam_tasks.typ"
