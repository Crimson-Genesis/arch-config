
# Markdown Syntax Guide

## 1. Headings
Headings are used to create titles or subtitles in Markdown. You use one or more `#` symbols followed by a space and the heading text. The number of `#` symbols determines the level of the heading, from 1 to 6.

```markdown
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
```

## 2. Paragraphs
Paragraphs are simply blocks of text separated by one or more blank lines. No special syntax is required.

```markdown
This is a paragraph.

This is another paragraph.
```

## 3. Emphasis
You can apply emphasis to text by using `*` or `_` for **italic** text, and `**` or `__` for **bold** text.

```markdown
*italic* or _italic_

**bold** or __bold__

**_bold and italic_**
```

## 4. Lists
- **Unordered Lists**: Use `*`, `+`, or `-` followed by a space to create unordered lists.

```markdown
* Item 1
* Item 2
  * Subitem 1
  * Subitem 2
```

- **Ordered Lists**: Use numbers followed by a period and a space for ordered lists.

```markdown
1. First item
2. Second item
   1. Subitem 1
   2. Subitem 2
```

## 5. Links
Links are created using `[text](URL)` syntax.

```markdown
[Google](https://www.google.com)
```

- **Links with Titles**: You can also add a title to the link that appears when the user hovers over it.

```markdown
[Google](https://www.google.com "Google Homepage")
```

## 6. Images
Images are similar to links but begin with an exclamation mark (`!`).

```markdown
![Alt text](https://example.com/image.jpg)
```

- **Images with Titles**: You can also add a title to an image.

```markdown
![Alt text](https://example.com/image.jpg "Image Title")
```

## 7. Blockquotes
Blockquotes are used to display quoted text and are created with the `>` symbol.

```markdown
> This is a blockquote.
> 
> It can span multiple lines.
```

You can nest blockquotes by using multiple `>` symbols.

```markdown
> This is a blockquote.
> > Nested blockquote.
```

## 8. Code
- **Inline Code**: Wrap inline code in backticks (`` ` ``).

```markdown
Here is `inline code`.
```

- **Code Blocks**: Use three backticks (``````) or indent with four spaces for block-level code.

```markdown
```
def greet():
    print("Hello, World!")
```
```

For language-specific syntax highlighting, specify the language after the first set of backticks.

```markdown
```python
def greet():
    print("Hello, World!")
```
```

## 9. Horizontal Rules
A horizontal rule (a line) can be created with three dashes (`---`), asterisks (`***`), or underscores (`___`).

```markdown
---
or
***
or
___
```

## 10. Tables
Tables are created using the `|` symbol to separate columns and `-` for the header separator.

```markdown
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Row 1    | Data 1   | Data 2   |
| Row 2    | Data 3   | Data 4   |
```

- **Alignment**: You can align text to the left, center, or right by adding colons to the header separator.

```markdown
| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:---------------:|--------------:|
| Data 1       | Data 2          | Data 3        |
| Data 4       | Data 5          | Data 6        |
```

## 11. Strikethrough
Strikethrough text is created by wrapping the text with two tildes (`~~`).

```markdown
~~This text is strikethrough~~
```

## 12. Escaping Characters
If you need to display Markdown syntax characters (like `*`, `#`, etc.), you can escape them with a backslash (`\`).

```markdown
\*escaped asterisk\*
```

## 13. Task Lists
Task lists are created with `- [ ]` for an unchecked box and `- [x]` for a checked box.

```markdown
- [ ] Task 1
- [x] Task 2
- [ ] Task 3
```

## 14. HTML Tags
You can embed raw HTML within Markdown for advanced formatting. The HTML will render as usual when the Markdown is converted to HTML.

```markdown
<b>Bold using HTML</b>
```

## 15. Footnotes
Footnotes can be added using `[^1]` for the citation and a matching `[1]:` link at the end.

```markdown
Here is a reference[^1].

[^1]: This is the footnote text.
```

## 16. Definition Lists
You can create definition lists by separating the term and definition with a colon.

```markdown
Term 1
: Definition 1

Term 2
: Definition 2
```

## 17. Inline HTML Elements
You can mix inline HTML with Markdown, such as adding `<b>`, `<i>`, or `<span>` tags to change the styling of text.

```markdown
This is <b>bold</b> and this is <i>italic</i>.
```

## 18. Comments
You can add comments that won't be displayed in the rendered output by using the HTML comment syntax (`<!-- -->`).

```markdown
<!-- This is a comment -->
```

## 19. Math (LaTeX)
For mathematical expressions, you can use LaTeX syntax enclosed in single or double dollar signs (`$` or `$$`).

```markdown
Inline math: $E = mc^2$

Block math:
$$
E = mc^2
$$
```

## 20. Definition of Abbreviations
Abbreviations can be defined using an inline style with square brackets.

```markdown
*[HTML]: Hypertext Markup Language
```

This allows you to refer to it later as `[HTML]`, and it will display as the defined abbreviation.

---
