# IDUH Org-Mode Static Site Generator

A minimal, elegant static site generator for Emacs Org-Mode files. Convert your org files into beautifully styled HTML pages with zero configuration.

## Features

- **Simple Org-Mode syntax** – titles, subtitles, sections, paragraphs, blockquotes, images
- **Inline formatting** – bold, italic, underline, strikethrough
- **Beautiful default styling** – responsive, dark mode support, Google Fonts
- **Batch processing** – generate an entire site from a directory of org files
- **Customizable templates** – optional header/footer templates
- **Static file handling** – CSS and assets are properly linked for HTTP serving

---

## Directory Structure

```
your-project/
├── posts/                          # Source org files (configurable)
│   ├── my-first-post.org
│   ├── another-article.org
│   └── assets/                     # Post-specific images/media
│       └── example-image.png
│
├── templates/                      # Optional HTML templates
│   ├── header.html                 # Site header/navigation
│   └── footer.html                 # Site footer
│
├── static/                         # Static assets
│   ├── css/
│   │   └── style.css              # Main stylesheet
│   └── images/                     # Site-wide images (logo, favicon, etc.)
│
├── public/                         # Generated output (configurable)
│   ├── my-first-post.html         # Generated from posts/my-first-post.org
│   ├── another-article.html       # Generated from posts/another-article.org
│   ├── css/
│   │   └── style.css              # Copied from static/
│   └── assets/
│       └── example-image.png      # Copied from posts/assets/
│
└── config.el                       # Site configuration (optional)
```

---

### Supported Org Syntax

| Feature | Org Syntax | Notes |
| :--- | :--- | :--- |
| **Title** | `#+TITLE: My Title` | Mandatory. Sets page `<title>` and `h1`. |
| **Date** | `#+DATE: 2024-12-24` | Mandatory. Used for metadata and display. |
| **Subtitle** | `#+SUBTITLE: My Subtitle` | Optional. |
| **Metadata** | `#+AUTHOR: Name`, `#+DESCRIPTION: Text` | Optional. Used for meta tags. |
| **Headings** | `* Section Heading` | **Single-level only**. Nested headings error. |
| **Images** | `[[./src.png][Alt Text]]` | **Alt text is mandatory**. |
| **Quotes** | `#+BEGIN_QUOTE` ... `#+END_QUOTE` | Standard Org quoting. |
| **Formatting** | `*bold*`, `/italic/`, `_underline_`, `+strike+` | Standard inline formatting. |

> [!IMPORTANT]
> **Key Constraints:**
> - **Mandatory Fields:** Every file must have `#+TITLE` and `#+DATE`.
> - **Flat Hierarchy:** Only single-asterisk `*` headings are supported.
> - **Descriptive Images:** All images must include alt text: `[[path][description]]`.


---

## Configuration

### Basic Configuration Variables

| Variable                           | Default     | Description                           |
|------------------------------------|-------------|---------------------------------------|
| `iduh-org-ssg-posts-directory`     | `"posts/"`  | Source directory for org files        |
| `iduh-org-ssg-output-directory`    | `"public/"` | Output directory for generated HTML   |
| `iduh-org-ssg-static-directory`    | `"static/"` | Static assets directory               |
| `iduh-org-ssg-templates-directory` | `"templates/"` | Optional HTML templates            |
| `iduh-org-ssg-css-path`            | `"css/style.css"` | CSS path relative to output     |
| `iduh-org-ssg-header-template`     | `nil`       | Path to header HTML template          |
| `iduh-org-ssg-footer-template`     | `nil`       | Path to footer HTML template          |

### Example Configuration (config.el)

```elisp
;; Load the SSG package
(require 'iduh-org-mode-ssg)

;; Configure directories
(setq iduh-org-ssg-posts-directory "~/blog/content/")
(setq iduh-org-ssg-output-directory "~/blog/public/")
(setq iduh-org-ssg-static-directory "~/blog/static/")

;; Optional: Enable templates
(setq iduh-org-ssg-header-template "~/blog/templates/header.html")
(setq iduh-org-ssg-footer-template "~/blog/templates/footer.html")

;; Generate the site
(iduh-org-ssg-build-site)
```

---

## Template System

Templates are optional HTML files that wrap around your generated content.

### Header Template (templates/header.html)

```html
<header class="site-header">
  <nav>
    <a href="/" class="logo">My Blog</a>
    <ul>
      <li><a href="/about.html">About</a></li>
      <li><a href="/archive.html">Archive</a></li>
    </ul>
  </nav>
</header>
```

### Footer Template (templates/footer.html)

```html
<footer class="site-footer">
  <p>&copy; 2024 My Blog. All rights reserved.</p>
</footer>
```

### Template Variables

Templates can include placeholders that get replaced during generation:

| Placeholder         | Description                        |
|---------------------|------------------------------------|
| `{{title}}`         | Post title from `#+TITLE`          |
| `{{date}}`          | Publication date from `#+DATE`     |
| `{{author}}`        | Author from `#+AUTHOR`             |
| `{{year}}`          | Current year                       |

---

## Generated HTML Structure

Each org file generates an HTML file with this structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Post Title</title>
  <meta name="generator" content="iduh-org-mode-ssg">
  <meta name="date" content="2024-12-24">
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <!-- Optional: Header template content -->
  
  <article>
    <header>
      <h1 class="title">Post Title</h1>
      <p class="subtitle">Optional subtitle</p>
      <time class="published-date" datetime="2024-12-24">December 24, 2024</time>
    </header>
    
    <section>
      <h2>Section Heading</h2>
      <p>Content...</p>
    </section>
  </article>
  
  <!-- Optional: Footer template content -->
</body>
</html>
```

---

## Usage

### Single File Generation

```elisp
;; Generate a single org file to HTML
(iduh-org-ssg-generate-file "posts/my-post.org" "public/")
```

### Batch Site Generation

```elisp
;; Generate all org files in posts/ to public/
(iduh-org-ssg-build-site)

;; Or with custom directories
(iduh-org-ssg-build-site 
  :posts "content/"
  :output "dist/")
```

### Interactive Commands

- `M-x iduh-org-ssg-build-site` – Build the entire site
- `M-x iduh-org-ssg-generate-file` – Generate a single file
- `M-x iduh-org-ssg-preview` – Preview current org file in browser
- `M-x iduh-org-ssg-clean` – Remove all generated files in output directory

---

## Serving the Site

The `public/` directory is designed to be served by any static HTTP server:

### Using Emacs (simple-httpd)

```elisp
(require 'simple-httpd)
(setq httpd-root "~/your-project/public/")
(httpd-start)
;; Site available at http://localhost:8080
```


### Using Python

```bash
cd public/
python -m http.server 8000
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           IDUH Org-Mode SSG                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐    ┌──────────────────┐    ┌────────────────────────┐   │
│  │  Org Files   │───▶│  Parser Module   │───▶│  Document AST (plist)  │   │
│  │  (posts/)    │    │                  │    │  :title, :date,        │   │
│  └──────────────┘    │  - Metadata      │    │  :sections, :content   │   │
│                      │  - Sections      │    └───────────┬────────────┘   │
│                      │  - Inline fmt    │                │                │
│                      └──────────────────┘                │                │
│                                                          ▼                │
│  ┌──────────────┐    ┌──────────────────┐    ┌────────────────────────┐   │
│  │  Templates   │───▶│  Generator       │◀───│  Document AST          │   │
│  │  (optional)  │    │  Module          │    │                        │   │
│  └──────────────┘    │                  │    └────────────────────────┘   │
│                      │  - HTML output   │                                 │
│  ┌──────────────┐    │  - Template      │    ┌────────────────────────┐   │
│  │  Static      │    │    injection     │───▶│  HTML Files            │   │
│  │  Assets      │    │  - Asset paths   │    │  (public/)             │   │
│  │  (static/)   │    └──────────────────┘    └────────────────────────┘   │
│  └──────────────┘                                                         │
│         │                                                                 │
│         └─────────────────────────Copied to public/───────────────────────│
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

### Module Responsibilities

| Module         | Responsibility                                                    |
|----------------|-------------------------------------------------------------------|
| **Parser**     | Read org files, extract metadata, build AST                       |
| **Generator**  | Convert AST to HTML, apply templates, resolve asset paths         |
| **Builder**    | Orchestrate file discovery, invoke parser/generator, copy assets  |
| **Config**     | Manage user configuration, provide defaults                       |

---

## Filename Convention

Generated HTML files are named based on the org file's `#+TITLE`:

| Org File               | #+TITLE              | Generated HTML          |
|------------------------|----------------------|-------------------------|
| `my-post.org`          | `My First Post`      | `my-first-post.html`    |
| `2024-recap.org`       | `Year in Review`     | `year-in-review.html`   |
| `intro.org`            | `Getting Started`    | `getting-started.html`  |

The title is:
1. Converted to lowercase
2. Spaces replaced with hyphens
3. Special characters removed
4. `.html` extension added

---

## Error Handling

The SSG provides clear error messages for common issues:

| Error                    | Cause                                    | Solution                              |
|--------------------------|------------------------------------------|---------------------------------------|
| `Missing #+DATE`         | Org file has no `#+DATE` field           | Add `#+DATE: YYYY-MM-DD` to the file |
| `Sub-heading not allowed`| Used `** Heading` instead of `* Heading` | Use single-level headings only       |
| `Image without alt text` | `[[image.png]]` without description      | Use `[[image.png][Alt text]]`        |
| `Unclosed quote block`   | Missing `#+END_QUOTE`                    | Close your `#+BEGIN_QUOTE` blocks    |

---

## Roadmap

- [ ] Index page generation (list of all posts)
- [ ] RSS/Atom feed generation
- [ ] Tag/category pages
- [ ] Syntax highlighting for code blocks
- [ ] Table support
- [ ] Incremental builds (only changed files)

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
