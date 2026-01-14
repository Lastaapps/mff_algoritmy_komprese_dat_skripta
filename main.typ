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

// #include "notes/overview.typ"

#set heading(numbering: "1.1.")

// #include "notes/00-example-lecture.typ"

#set heading(numbering: "A.1")
#counter(heading).update(0)

// #include "notes/exam_tasks.typ"
