This is a pandoc filter designed to be used with [Pandoc Typst PDF (`ptp`)](https://github.com/cskeeters/ptp) that enables cross references with markdown links like `[Introduction](#intro)`.

# Example Usage

    ---
    filters:
      - pandoc-internal-link/0.1.0/internal-link.lua
    ---

    Jump to the [Introduction](#introduction).

    # Introduction

## No Section Numbering

In Typst, cross references to headings only work when section numbering is
enabled.

    #set heading(numbering: "1.1 ")

If the template doesn't enable section numbers, you can add this to
the Markdown, or the template you are using.

    ```{=typst}
    #let blue-underline(it) = underline[
    #set text(blue)
    #it
    ]

    #show link: blue-underline
    #show ref: it => {
    if it.element.numbering == none {
        // Use your custom scheme
        link(it.target, it.element.body)
    } else {
        // Default `ref`
        it
    }
    }
    ```


# Usage

```sh
ptp doc.md
```

## Manual

If you are not using `ptp`, you can run the filter with:

```sh
pandoc -L pandoc-internal/link/0.1.0/internal-link.lua doc.md -o doc.typ
typst compile doc.typ
```

# Installation

```
mkdir -p ~/.pandoc/filters/pandoc-internal-link
cd ~/.pandoc/filters/pandoc-internal-link
git clone https://github.com/cskeeters/pandoc-internal-link 0.1.0
cd 0.1.0
git switch --detach v0.1.0
```
