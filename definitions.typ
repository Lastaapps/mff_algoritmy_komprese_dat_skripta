#let info_box(title: none, body) = {
  block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    [
      #if title != none {
        text(weight: "bold", title)
        parbreak()
      }
      #body
    ],
  )
}

#let example_box(title: none, body) = {
  box(
    stroke: 1pt + black,
    inset: 8pt,
    [
      #if title != none {
        text(weight: "bold", title)
        parbreak()
      }
      #body
    ],
  )
}

#let code_box(body) = {
  rect(
    width: 100%,
    inset: 8pt,
    fill: luma(240),
    radius: 4pt,
    body,
  )
}

#let theorem(title: none, body) = {
  info_box(
    title: if title != none { "Theorem: " + title } else { "Theorem" },
    body: body,
  )
}

#let lemma(title: none, body) = {
  info_box(
    title: if title != none { "Lemma: " + title } else { "Lemma" },
    body: body,
  )
}

#let observation(title: none, body) = {
  info_box(
    title: if title != none { "Observation: " + title } else { "Observation" },
    body: body,
  )
}

#let proof(body) = {
  example_box(title: "Proof", body: body)
}

#let task(title: none, body) = {
  info_box(
    title: if title != none { "Task: " + title } else { "Task" },
    body: body,
  )
}

