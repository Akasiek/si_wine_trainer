// Import and init Codly - better codeblocks
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#let icon(codepoint) = {
  box(
    height: 0.8em,
    baseline: 0.05em,
    image(codepoint)
  )
  h(0.1em)
}
#codly(languages: codly-languages)

#set text(lang: "pl")
#set heading(numbering: "1.")
#set page(numbering: "1", margin: (x: 2.5cm, y: 2.5cm))
#set par(justify: true, leading: 0.8em, linebreaks: "optimized")
#set block(spacing: 1.45em, above: 1.3em)
// Set font and color for inline code
#show raw: set text(font: "JetBrains Mono", fill: rgb(60, 163, 88, 255) )
// Change color of figure's captions
#show figure: set text(fill: rgb(80, 80, 80, 255), style: "italic")



/* --- End of configuration --- */

#align([
  #text([#smallcaps("Politechnika Rzeszowska")\ ], size: 1.2em)
  #text([#smallcaps("Wydział Elektrotechniki i Informatyki")\ ], size: 1em)

  #image("./images/weii.png", width: 12cm)

  #text([Sztuczna Inteligencja\ ], size: 1.2em, weight: "bold")
  #text([Klasyfikator wina w Burn\ ], size: 1.5em, weight: "black")
  #text([Projekt\ ], size: 1em, weight: "bold")
], center + horizon)

#align(grid(
  columns: (auto, 1fr),
  [#align(text("24.01.2025 r.", size: 0.8em), end)],
  [#align(text(smallcaps("Kamil Pomykała, 174725"), size: 1.1em), end)],
), right + bottom)

#set align(start + top)

#pagebreak()